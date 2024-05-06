#ifndef UIIMAGE_EXTENSION_H
#define UIIMAGE_EXTENSION_H

#import "facesdk/facesdk.h"

@interface UIImage(Extensions)
- (UIImage *)cropFaceWithFaceBox:(FaceBox *)faceBox;
- (UIImage *)fixOrientation;
- (UIImage *)rotateWithRadians:(CGFloat)radians;
- (UIImage *)flipHorizontally;
@end

#endif
