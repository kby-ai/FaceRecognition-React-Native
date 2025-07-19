
#import "NativeCamera.h"
#import "FaceRecognitionSdkViewManager.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>

#import <React/UIView+React.h>

@interface NativeCamera ()


@property (nonatomic, weak) FaceRecognitionSdkViewManager *manager;
@property (nonatomic, weak) RCTBridge *bridge;

@end

@implementation NativeCamera
{
}

- (id)initWithManager:(FaceRecognitionSdkViewManager*)manager bridge:(RCTBridge *)bridge
{
    
    if ((self = [super init])) {
        self.manager = manager;
        self.bridge = bridge;
        // [self.manager initializeCaptureSessionInput:AVMediaTypeVideo];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.manager.previewLayer.frame = self.bounds;
    [self setBackgroundColor:[UIColor blackColor]];
    [self.layer insertSublayer:self.manager.previewLayer atIndex:0];
}

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex
{
    [self insertSubview:view atIndex:atIndex + 1];
    return;
}

- (void)removeReactSubview:(UIView *)subview
{
    [subview removeFromSuperview];
    return;
}

- (void)removeFromSuperview
{
    // [self.manager stopSession];
    [super removeFromSuperview];
}



@end
