#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>
#import <React/UIView+React.h>
#import <AVFoundation/AVFoundation.h>

//#import "FaceBox.h"

@class FaceRecognitionSdkViewManager;

@interface NativeCamera : UIView

@property (nonatomic, copy) RCTBubblingEventBlock onFaceDetected;

- (id)initWithManager:(FaceRecognitionSdkViewManager*)manager bridge:(RCTBridge *)bridge;
@end
