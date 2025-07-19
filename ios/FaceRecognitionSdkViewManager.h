#ifndef FACERECOGNITIONSDK_VIEW_MANAGER_H
#define FACERECOGNITIONSDK_VIEW_MANAGER_H

#import <React/RCTViewManager.h>
#import <React/RCTEventEmitter.h>
#import <AVFoundation/AVFoundation.h>
#import <React/RCTBridgeModule.h>

@class NativeCamera;

@interface FaceRecognitionSdkViewManager : RCTViewManager <AVCaptureVideoDataOutputSampleBufferDelegate>

+(void) startCamera;
+(void) stopCamera;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;
@property (nonatomic, strong) id runtimeErrorHandlingObserver;
@property (nonatomic, assign) NSInteger presetCamera;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NativeCamera *camera;


- (void)initializeCaptureSessionInput:(NSString*)type;
- (void)startSession;
- (void)stopSession;

@end


#endif
