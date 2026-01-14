//
//  FaceRecognitionSdkViewManager.m
//

#import "FaceRecognitionSdkViewManager.h"
#import <React/RCTLog.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

// Face SDK + helpers
#if !TARGET_OS_SIMULATOR
#import "facesdk/facesdk.h"
#endif
#import "UIImageExtension.h"
#import <TargetConditionals.h>

// Reference to the FaceSDKModule global instance so we can emit events.
// This variable is defined in FaceSDKModule.m as: FaceSDKModule* g_faceSDKModule = nil;
extern id g_faceSDKModule;

@implementation FaceRecognitionSdkViewManager

// React Native module name
RCT_EXPORT_MODULE(FaceRecognitionSdkView)

// Example prop
RCT_EXPORT_VIEW_PROPERTY(color, NSString)

#pragma mark - Create Native View

- (UIView *)view
{
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor blackColor];

    // Always use the singleton (shared) instance
    FaceRecognitionSdkViewManager *mgr = [FaceRecognitionSdkViewManager sharedInstance];

    // Create preview layer using singleton session
    mgr.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:mgr.session];
    mgr.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    mgr.previewLayer.frame = container.bounds;
    mgr.previewLayer.needsDisplayOnBoundsChange = YES;

    [container.layer addSublayer:mgr.previewLayer];

    // Ensure the preview layer matches the container after layout
    dispatch_async(dispatch_get_main_queue(), ^{
        mgr.previewLayer.frame = container.bounds;
    });

    // Start the camera when view is created
    [FaceRecognitionSdkViewManager startCamera];

    return container;
}

#pragma mark - Singleton Manager

+ (instancetype)sharedInstance
{
    static FaceRecognitionSdkViewManager *shared = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        shared = [[FaceRecognitionSdkViewManager alloc] init];
        [shared initializeSession];
    });

    return shared;
}

#pragma mark - Camera Session Setup

- (void)initializeSession
{
    self.sessionQueue = dispatch_queue_create("face.camera.session.queue", DISPATCH_QUEUE_SERIAL);
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;

    [self initializeCaptureSessionInput:@"front"];
}

- (void)initializeCaptureSessionInput:(NSString *)type
{
    dispatch_async(self.sessionQueue, ^{

        // Select FRONT CAMERA explicitly
        AVCaptureDevice *device = nil;

        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *d in devices) {
            if (d.position == AVCaptureDevicePositionFront) {
                device = d;
                break;
            }
        }

        // Fallback to default video device (rare)
        if (!device) {
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }

        NSError *error = nil;

        self.videoCaptureDeviceInput =
            [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

        if (error) {
            RCTLogError(@"Camera input error: %@", error);
            return;
        }

        // Remove existing inputs (safe-guard) then add
        for (AVCaptureInput *input in self.session.inputs) {
            [self.session removeInput:input];
        }

        if ([self.session canAddInput:self.videoCaptureDeviceInput]) {
            [self.session addInput:self.videoCaptureDeviceInput];
        }

        // Add video frame output (remove previous outputs first)
        for (AVCaptureOutput *out in self.session.outputs) {
            [self.session removeOutput:out];
        }

        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];

        // Configure pixel format to a common YUV/RGB type if needed (default typically works)
        // output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};

        [output setSampleBufferDelegate:self queue:self.sessionQueue];
        output.alwaysDiscardsLateVideoFrames = YES;

        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];

            // Ensure orientation / connection settings
            AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
            if (connection.isVideoOrientationSupported) {
                connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
            if (connection.isVideoMirroringSupported && device.position == AVCaptureDevicePositionFront) {
                connection.videoMirrored = YES;
            }
        }
    });
}

#pragma mark - Start / Stop Camera

+ (void)startCamera
{
    [[FaceRecognitionSdkViewManager sharedInstance] startSession];
}

+ (void)stopCamera
{
    [[FaceRecognitionSdkViewManager sharedInstance] stopSession];
}

- (void)startSession
{
    dispatch_async(self.sessionQueue, ^{
        if (!self.session.isRunning) {
            [self.session startRunning];
            RCTLogInfo(@"Camera started");
        }
    });
}

- (void)stopSession
{
    dispatch_async(self.sessionQueue, ^{
        if (self.session.isRunning) {
            [self.session stopRunning];
            RCTLogInfo(@"Camera stopped");
        }
    });
}

#pragma mark - Helpers: Convert sampleBuffer -> UIImage

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!imageBuffer) return nil;

    // Lock the buffer
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    CIImage *ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0, width, height)];

    // For front camera we often need to rotate/mirror. We'll use UIImageOrientationRight
    UIImage *image = [UIImage imageWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationRight];

    CGImageRelease(videoImage);
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    return image;
}

#pragma mark - Frame Processing Delegate

- (void)captureOutput:(AVCaptureOutput *)output
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {

        // Convert buffer to UIImage
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        if (!image) return;

        // Fix orientation if needed (using your UIImageExtension)
        UIImage *fixedImage = [image fixOrientation];
        if (!fixedImage) return;

#if TARGET_OS_SIMULATOR
        // FaceSDK not supported on simulator, skip processing
        return;
#else
        // Run face detection
        NSArray *faceBoxes = [FaceSDK faceDetection:fixedImage];
        if (!faceBoxes || faceBoxes.count == 0) {
            return;
        }

        // We'll emit an event for the first detected face (you can modify to emit multiple)
        FaceBox *box = (FaceBox *)faceBoxes[0];

        // Extract templates
        NSData *templates = [FaceSDK templateExtraction:fixedImage faceBox:box];
        if (!templates || templates.length == 0) {
            return;
        }

        // Crop face image and encode
        UIImage *faceImage = [fixedImage cropFaceWithFaceBox:box];
        NSData *faceJpg = UIImageJPEGRepresentation(faceImage, 1.0);

        // Prepare event payload (mirror of extractFaces keys)
        NSMutableDictionary *event = [NSMutableDictionary dictionary];

        event[@"x1"] = [NSString stringWithFormat:@"%f", box.x1];
        event[@"y1"] = [NSString stringWithFormat:@"%f", box.y1];
        event[@"x2"] = [NSString stringWithFormat:@"%f", box.x2];
        event[@"y2"] = [NSString stringWithFormat:@"%f", box.y2];

        event[@"liveness"] = @(box.liveness);
        event[@"yaw"] = @(box.yaw);
        event[@"roll"] = @(box.roll);
        event[@"pitch"] = @(box.pitch);

        event[@"templates"] = [templates base64EncodedStringWithOptions:0];
        event[@"faceJpg"] = [faceJpg base64EncodedStringWithOptions:0];
        event[@"frameWidth"] = [NSString stringWithFormat:@"%d", (int)fixedImage.size.width];
        event[@"frameHeight"] = [NSString stringWithFormat:@"%d", (int)fixedImage.size.height];

        // Optionally include an imagePath if you save the image to disk (not doing here)
        // Emit to JS on main thread using global FaceSDKModule instance if available
        if (g_faceSDKModule != nil && [g_faceSDKModule respondsToSelector:@selector(sendEventWithName:body:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [g_faceSDKModule sendEventWithName:@"onFaceDetected" body:event];
            });
        }
#endif
    }
}

@end
