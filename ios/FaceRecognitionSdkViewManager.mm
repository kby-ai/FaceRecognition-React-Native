#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import "FaceSDKModule.h"
#import "facesdk/facesdk.h"
#import "UIImageExtension.h"
#import "FaceRecognitionSDKViewManager.h"
#import <AVFoundation/AVFoundation.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <AVFoundation/AVFoundation.h>
#import "NativeCamera.h"

extern FaceSDKModule* g_faceSDKModule; 

int g_cameraLens = 1;

@interface FaceRecognitionSdkViewManager () {

    dispatch_queue_t videoDataOutputQueue;
    UIDeviceOrientation deviceOrientation;
}

@property (atomic) BOOL isProcessingFrame;
@property (atomic) BOOL cameraRunning;
@end

FaceRecognitionSdkViewManager* g_faceRecognitionSdkViewManager = nil;

@implementation FaceRecognitionSdkViewManager

RCT_EXPORT_MODULE(FaceRecognitionSdkView)

- (id)init {
    if ((self = [super init])) {
        self.sessionQueue = dispatch_queue_create("cameraManagerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (UIView *)view
{
  g_faceRecognitionSdkViewManager = self;

  self.session = [AVCaptureSession new];
#if !(TARGET_IPHONE_SIMULATOR)
  self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
  self.previewLayer.needsDisplayOnBoundsChange = YES;
#endif
  
  if(!self.camera){
      self.camera = [[NativeCamera alloc] initWithManager:self bridge:self.bridge];
  }
  return self.camera;
}

RCT_CUSTOM_VIEW_PROPERTY(livenessLevel, NSInteger, UIView)
{
//    NSInteger livenessLevel = [RCTConvert NSInteger:json];
//    NSLog(@"set liveness level %ld", (long)livenessLevel);
}

RCT_CUSTOM_VIEW_PROPERTY(cameraLens, NSInteger, UIView)
{
    NSInteger cameraLens = [RCTConvert NSInteger:json];
    g_cameraLens = (int)cameraLens;
}

RCT_EXPORT_VIEW_PROPERTY(onFaceDetected, RCTBubblingEventBlock)

- hexStringToColor:(NSString *)stringToConvert
{
  NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
  NSScanner *stringScanner = [NSScanner scannerWithString:noHashString];

  unsigned hex;
  if (![stringScanner scanHexInt:&hex]) return nil;
  int r = (hex >> 16) & 0xFF;
  int g = (hex >> 8) & 0xFF;
  int b = (hex) & 0xFF;

  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

- (void)startSession {
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
  // if(self.camera == nil) return;
  if(self.cameraRunning == true) return;

  self.cameraRunning = true;

    dispatch_async(self.sessionQueue, ^{
        [self initializeCaptureSessionInput:AVMediaTypeVideo];

        if (self.presetCamera == AVCaptureDevicePositionUnspecified) {
            self.presetCamera = AVCaptureDevicePositionBack;
        }
        
        self.presetCamera = AVCaptureDevicePositionFront;
        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        NSString     *key           = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber     *value         = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [videoDataOutput setVideoSettings:videoSettings];

        videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        videoDataOutputQueue = dispatch_queue_create("camera-video-queue", NULL);
        [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
        
        if ([self.session canAddOutput:videoDataOutput]) {
            [self.session addOutput:videoDataOutput];
        }
              

          [self.session startRunning];
    });
}

- (void)stopSession {
#if TARGET_IPHONE_SIMULATOR
    self.camera = nil;
    return;
#endif
    self.cameraRunning = false;
    self.camera = nil;
    [self.previewLayer removeFromSuperlayer];
    [self.session commitConfiguration];
    [self.session stopRunning];
    for(AVCaptureInput *input in self.session.inputs) {
        [self.session removeInput:input];
    }
}

- (void)initializeCaptureSessionInput:(NSString *)type {
    dispatch_async(self.sessionQueue, ^{
        [self.session beginConfiguration];
        
        NSError *error = nil;
        AVCaptureDevice *captureDevice = nil;
        NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for(AVCaptureDevice* camera in devices) {
          if(g_cameraLens == 0) {
            if([camera position] == AVCaptureDevicePositionBack) {
                captureDevice = camera;
                break;
            }
          } else {
            if([camera position] == AVCaptureDevicePositionFront) {
                captureDevice = camera;
                break;
            }
          }
        }
        
        if (captureDevice == nil) {
            return;
        }
                
        AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (error || captureDeviceInput == nil) {
            NSLog(@"%@", error);
            return;
        }
        
        if (type == AVMediaTypeVideo) {
            [self.session removeInput:self.videoCaptureDeviceInput];
        }
        
        if ([self.session canAddInput:captureDeviceInput]) {
            [self.session addInput:captureDeviceInput];
            if (type == AVMediaTypeVideo) {
                self.videoCaptureDeviceInput = captureDeviceInput;
            }
        }
        
        [self.session commitConfiguration];
    });
}

// Function to rotate the previewLayer according to the device's orientation.
- (void)updatePreviewLayerOrientation {
    //Get Preview Layer connection
    AVCaptureConnection *previewLayerConnection = self.previewLayer.connection;
    if ([previewLayerConnection isVideoOrientationSupported]) {
        switch(deviceOrientation) {
            case UIDeviceOrientationPortrait:
                [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
                break;
            case UIDeviceOrientationLandscapeLeft:
                // Not sure why I need to invert left and right, but this is what is needed for
                // it to function properly. Otherwise it reverses the image.
                [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
                break;
            case UIDeviceOrientationLandscapeRight:
                [previewLayerConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
                break;
        }
    }
}

- (void)deviceDidRotate:(NSNotification *)notification
{
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    
    // Ignore changes in device orientation if unknown, face up, or face down.
    if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) {
        return;
    }
    deviceOrientation = currentOrientation;
    [self updatePreviewLayerOrientation];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {

    @autoreleasepool {
        if (self.isProcessingFrame) {
            return;
        }
        self.isProcessingFrame = YES;

        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (pixelBuffer == NULL) {
            return;
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

        CIContext *context = [CIContext context];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
        UIImage *image;
        if(g_cameraLens == 1) {
            image = [UIImage imageWithCGImage:cgImage scale: 1.0f orientation: UIImageOrientationDownMirrored];
        } else {
            image = [UIImage imageWithCGImage:cgImage];
        }
        [UIImage imageWithCGImage:cgImage scale: 1.0f orientation: UIImageOrientationDownMirrored];
        CGImageRelease(cgImage);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);

        UIImage *capturedImage = [image rotateWithRadians:M_PI_2];
                
        NSMutableArray* faceBoxesMap = [[NSMutableArray alloc] init];
        NSArray *faceBoxes = [FaceSDK faceDetection:capturedImage];
        for(FaceBox* faceBox in faceBoxes) {
            NSData* templates = [FaceSDK templateExtraction: capturedImage faceBox: faceBox];
            if([templates length] == 0) continue;

            UIImage* faceImage = [capturedImage cropFaceWithFaceBox:faceBox];
            NSData *faceJpg = UIImageJPEGRepresentation(faceImage, 1.0);
            
            NSMutableDictionary *e = [[NSMutableDictionary alloc] init];
            [e setValue:[NSString stringWithFormat:@"%f", (float)faceBox.x1] forKey:@"x1"];
            [e setValue:[NSString stringWithFormat:@"%f", (float)faceBox.y1] forKey:@"y1"];
            [e setValue:[NSString stringWithFormat:@"%f", (float)faceBox.x2] forKey:@"x2"];
            [e setValue:[NSString stringWithFormat:@"%f", (float)faceBox.y2] forKey:@"y2"];
            [e setValue:[NSString stringWithFormat:@"%f", faceBox.liveness] forKey:@"liveness"];
            [e setValue:[NSString stringWithFormat:@"%f", faceBox.yaw] forKey:@"yaw"];
            [e setValue:[NSString stringWithFormat:@"%f", faceBox.roll] forKey:@"roll"];
            [e setValue:[NSString stringWithFormat:@"%f", faceBox.pitch] forKey:@"pitch"];
            [e setValue:[templates base64EncodedStringWithOptions: 0] forKey:@"templates"];
            [e setValue:[faceJpg base64EncodedStringWithOptions: 0] forKey:@"faceJpg"];
            [e setValue:[NSString stringWithFormat:@"%d", (int)capturedImage.size.width] forKey:@"frameWidth"];
            [e setValue:[NSString stringWithFormat:@"%d", (int)capturedImage.size.height] forKey:@"frameHeight"];

            [faceBoxesMap addObject:e];
        }

       if(g_faceSDKModule != nil) {
           [g_faceSDKModule sendEventWithName: @"onFaceDetected" body: faceBoxesMap];
       }
        self.isProcessingFrame = NO;
    }
}

+(void) startCamera {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   if(g_faceRecognitionSdkViewManager != nil) {
    [g_faceRecognitionSdkViewManager startSession];
   }    
  });
}

+(void) stopCamera {
  dispatch_async(dispatch_get_main_queue(), ^{
   if(g_faceRecognitionSdkViewManager != nil) {
    [g_faceRecognitionSdkViewManager stopSession];
   }
  });
}

@end
