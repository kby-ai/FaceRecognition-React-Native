#if !TARGET_OS_SIMULATOR
#import "facesdk/facesdk.h"
#endif
#import "UIImageExtension.h"
#import <React/RCTViewManager.h>
#import <React/RCTLog.h>
#import "FaceSDKModule.h"
#import "FaceRecognitionSdkViewManager.h"
#import <TargetConditionals.h>

int g_checkLivenessLevel = 0;

@implementation FaceSDKModule
RCT_EXPORT_MODULE(FaceSDKModule);

RCT_EXPORT_METHOD(setActivation:(NSString *)license resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
#if TARGET_OS_SIMULATOR
    reject(@"SIMULATOR_NOT_SUPPORTED", @"FaceSDK is not supported on iOS Simulator. Please use a physical device.", nil);
    return;
#else
    printf("setActivation\n");
    int ret = [FaceSDK setActivation:license];
    resolve(@(ret));
#endif
}

RCT_EXPORT_METHOD(initSDK:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
#if TARGET_OS_SIMULATOR
    reject(@"SIMULATOR_NOT_SUPPORTED", @"FaceSDK is not supported on iOS Simulator. Please use a physical device.", nil);
    return;
#else
    printf("initSDK\n");
    int ret = [FaceSDK initSDK];
    resolve(@(ret));
#endif
}

RCT_EXPORT_METHOD(setParam:(int)checkLivenessLevel resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("setParam\n");
    g_checkLivenessLevel = checkLivenessLevel;
    resolve(@(0));
}

#pragma mark - FIXED extractFaces FOR iOS

RCT_EXPORT_METHOD(extractFaces:(NSString*)imagePath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    printf("extract faces!\n");

    NSURL *url;

    // iOS FIX → Properly detect file paths
    if ([imagePath hasPrefix:@"file://"]) {
        NSString *cleanPath = [imagePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        url = [NSURL fileURLWithPath:cleanPath];
    }
    else if (![imagePath containsString:@"http"]) {
        url = [NSURL fileURLWithPath:imagePath];
    }
    else {
        url = [NSURL URLWithString:imagePath];
    }

    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];

    NSMutableArray *faceBoxesMap = [[NSMutableArray alloc] init];

    if (image != nil) {
#if TARGET_OS_SIMULATOR
        reject(@"SIMULATOR_NOT_SUPPORTED", @"FaceSDK is not supported on iOS Simulator. Please use a physical device.", nil);
        return;
#else
        printf("image size: %f, %f\n", image.size.width, image.size.height);

        UIImage *fixedImage = [image fixOrientation];
        NSArray *faceBoxes = [FaceSDK faceDetection:fixedImage];

        for (FaceBox *faceBox in faceBoxes) {

            NSData *templates = [FaceSDK templateExtraction:fixedImage faceBox:faceBox];
            if ([templates length] == 0) continue;

            UIImage *faceImage = [fixedImage cropFaceWithFaceBox:faceBox];
            NSData *faceJpg = UIImageJPEGRepresentation(faceImage, 1.0);

            NSMutableDictionary *e = [[NSMutableDictionary alloc] init];
            e[@"x1"] = [NSString stringWithFormat:@"%f", faceBox.x1];
            e[@"y1"] = [NSString stringWithFormat:@"%f", faceBox.y1];
            e[@"x2"] = [NSString stringWithFormat:@"%f", faceBox.x2];
            e[@"y2"] = [NSString stringWithFormat:@"%f", faceBox.y2];
            e[@"liveness"] = [NSString stringWithFormat:@"%f", faceBox.liveness];
            e[@"yaw"] = [NSString stringWithFormat:@"%f", faceBox.yaw];
            e[@"roll"] = [NSString stringWithFormat:@"%f", faceBox.roll];
            e[@"pitch"] = [NSString stringWithFormat:@"%f", faceBox.pitch];
            e[@"templates"] = [templates base64EncodedStringWithOptions:0];
            e[@"faceJpg"] = [faceJpg base64EncodedStringWithOptions:0];
            e[@"frameWidth"] = [NSString stringWithFormat:@"%d", (int)fixedImage.size.width];
            e[@"frameHeight"] = [NSString stringWithFormat:@"%d", (int)fixedImage.size.height];

            [faceBoxesMap addObject:e];
        }
#endif
    }

    resolve(faceBoxesMap);
}

RCT_EXPORT_METHOD(similarityCalculation:(NSString*)templates1
                  templates2:(NSString*)templates2
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:templates1
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:templates2
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];

#if TARGET_OS_SIMULATOR
    reject(@"SIMULATOR_NOT_SUPPORTED", @"FaceSDK is not supported on iOS Simulator. Please use a physical device.", nil);
    return;
#else
    if (data1 && data2) {
        float similarity = [FaceSDK similarityCalculation:data1 templates2:data2];
        resolve(@(similarity));
    } else {
        resolve(@(0.0f));
    }
#endif
}

RCT_EXPORT_METHOD(startCamera:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [FaceRecognitionSdkViewManager startCamera];
    resolve(@(0));
}

RCT_EXPORT_METHOD(stopCamera:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [FaceRecognitionSdkViewManager stopCamera];
    resolve(@(0));
}

FaceSDKModule *g_faceSDKModule = nil;

- (id)init
{
    printf("FaceModule init\n");
    if (self = [super init]) {
        g_faceSDKModule = self;
    }
    return self;
}

NSString *const kBeaconSighted = @"onFaceDetected";

- (NSDictionary<NSString *, NSString *> *)constantsToExport
{
  return @{ @"onFaceDetected": kBeaconSighted };
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onFaceDetected"];
}

@end
