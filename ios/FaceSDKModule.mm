#import "facesdk/facesdk.h"
#import "UIImageExtension.h"
#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import "FaceSDKModule.h"
#import "FaceRecognitionSdkViewManager.h"

int g_checkLivenessLevel = 0;


@implementation FaceSDKModule
RCT_EXPORT_MODULE(FaceSDKModule);

RCT_EXPORT_METHOD(setActivation:(NSString *)license  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("setActivation\n");
    int ret = [FaceSDK setActivation:license];
    resolve(@(ret));
}

RCT_EXPORT_METHOD(initSDK: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("initSDK\n");
    int ret = [FaceSDK initSDK];
    resolve(@(ret));
}

RCT_EXPORT_METHOD(setParam: (int) checkLivenessLevel resolve: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("setParam\n");
    g_checkLivenessLevel = checkLivenessLevel;
    resolve(@(0));
}

RCT_EXPORT_METHOD(extractFaces: (NSString*) imagePath resolve: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("extract faces!\n");
    NSURL* url = [NSURL URLWithString: imagePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    NSMutableArray* faceBoxesMap = [[NSMutableArray alloc] init];
    if(image != nil) {
        printf("image size: %f, %f\n", image.size.width, image.size.height);

        UIImage *fixedImage = [image fixOrientation];
        NSArray *faceBoxes = [FaceSDK faceDetection:fixedImage];
        
        for(FaceBox* faceBox in faceBoxes) {
            NSData* templates = [FaceSDK templateExtraction: fixedImage faceBox: faceBox];
            if([templates length] == 0) continue;

            UIImage* faceImage = [fixedImage cropFaceWithFaceBox:faceBox];
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
            [e setValue:[NSString stringWithFormat:@"%d", (int)fixedImage.size.width] forKey:@"frameWidth"];
            [e setValue:[NSString stringWithFormat:@"%d", (int)fixedImage.size.height] forKey:@"frameHeight"];

            [faceBoxesMap addObject:e];
        }
    }

    resolve(faceBoxesMap);
}

RCT_EXPORT_METHOD(similarityCalculation: (NSString*) templates1 templates2: (NSString*) templates2 resolve: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    // Convert base64 strings to NSData objects
    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:templates1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:templates2 options:NSDataBase64DecodingIgnoreUnknownCharacters];

    // Check if NSData objects are valid
    if (data1 != nil && data2 != nil) {
        // Perform similarity calculation using FaceSDK (replace this with the actual method)
        float similarity = [FaceSDK similarityCalculation:data1 templates2:data2];
        resolve(@(similarity));
    } else {
        resolve(@(0.0f));
    }
}


RCT_EXPORT_METHOD(startCamera: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
//    printf("start camera %d\n", [FaceRecognitionSdkViewManager requiresMainQueueSetup]);
    [FaceRecognitionSdkViewManager startCamera];
    resolve(@(0));
}

RCT_EXPORT_METHOD(stopCamera: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
//    printf("stop camera %d\n", FaceRecognitionSdkViewManager.faceRecognitionView == nil);
   [FaceRecognitionSdkViewManager stopCamera];
    resolve(@(0));
}

FaceSDKModule* g_faceSDKModule = nil;
- (id)init {
        printf("FaceModule init\n");
    if ((self = [super init])) {
        g_faceSDKModule = self;
    }
    return self;
}

NSString *const kBeaconSighted = @"onFaceDetected";

- (NSDictionary<NSString *, NSString *> *)constantsToExport {
  return @{ @"onFaceDetected": kBeaconSighted,
            };
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"onFaceDetected"
           ];
}


@end



