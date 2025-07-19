

#import "UIImageExtension.h"

@implementation UIImage (Extensions)

- (UIImage *)cropFaceWithFaceBox:(FaceBox *)faceBox {
    CGFloat centerX = (faceBox.x1 + faceBox.x2) / 2;
    CGFloat centerY = (faceBox.y1 + faceBox.y2) / 2;
    CGFloat cropWidth = (faceBox.x2 - faceBox.x1) * 1.4;
    
    CGFloat cropX1 = centerX - (cropWidth / 2);
    CGFloat cropX2 = centerY - (cropWidth / 2);
    CGRect cropRect = CGRectMake(cropX1, cropX2, cropWidth, cropWidth);
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedImageRef];
    CGImageRelease(croppedImageRef);
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(150, 150)];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [croppedImage drawInRect:CGRectMake(0, 0, 150, 150)];
    }];
    
    return newImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextConcatCTM(context, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *fixedImage = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(context);
    CGImageRelease(cgImage);
    
    return fixedImage;
}

- (UIImage *)rotateWithRadians:(CGFloat)radians {
    CGSize rotatedSize = CGRectApplyAffineTransform(CGRectMake(0, 0, self.size.width, self.size.height), CGAffineTransformMakeRotation(radians)).size;
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width / 2, rotatedSize.height / 2);
    CGContextRotateCTM(context, radians);
    [self drawInRect:CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height)];
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage ? rotatedImage : self;
}

- (UIImage *)flipHorizontally {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.size.width, 0);
    CGContextScaleCTM(context, -1.0, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *flippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return flippedImage;
}

@end
