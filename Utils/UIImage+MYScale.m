//
//  UIImage+MYScale.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import "UIImage+MYScale.h"


@implementation UIImage (MYScale)


#prama mark - Class Methods

+ (UIImage *)rotate:(UIImage *)image {
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    
    CGFloat scaleRatio = 1;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            // 在Release版本中，抛出异常而未处理会Crash
            // [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            return image;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
                       CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *)imageByScalingToSize:(UIImage*)sourceImage
                             Size:(CGSize)targetSize {
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = (CGBitmapInfo)kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp
        || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL,
                                       targetWidth,
                                       targetHeight,
                                       CGImageGetBitsPerComponent(imageRef),
                                       CGImageGetBytesPerRow(imageRef),
                                       colorSpaceInfo,
                                       bitmapInfo);
    } else {
        bitmap = CGBitmapContextCreate(NULL,
                                       targetHeight,
                                       targetWidth,
                                       CGImageGetBitsPerComponent(imageRef),
                                       CGImageGetBytesPerRow(imageRef),
                                       colorSpaceInfo,
                                       bitmapInfo);
    }
    
    if (!bitmap) {
        return nil;
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI / 2.0);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI / 2.0);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap,
                       CGRectMake(0, 0, targetWidth, targetHeight),
                       imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage*)image scaledFitToSize:(CGSize)newSize {
    
    CGRect scaleRect = [image scaleToFit:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake((newSize.width - scaleRect.size.width) / 2,
                                 (newSize.height - scaleRect.size.height) / 2,
                                 scaleRect.size.width,
                                 scaleRect.size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#prama mark - Instance Methods

- (UIImage *)scaleBySize:(CGSize)size {
	if (![self respondsToSelector:@selector(scale)]) {
		UIGraphicsBeginImageContext(size);
		[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	} else {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), YES, 2);
		[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	}
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage *)scaleBySizeNoDouble:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return scaledImage;
}

- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage *)cropRectBaseOrientation:(CGRect)bounds {
	CGRect cropRect = CGRectZero;
	switch (self.imageOrientation) {
		case UIImageOrientationUp:
			// do nothing.
			cropRect = bounds;
			break;
            
		case UIImageOrientationDown:
			cropRect = bounds;
			cropRect.origin.x = self.size.width - bounds.origin.x;
			cropRect.origin.y = self.size.height - bounds.origin.y;
			break;
            
		case UIImageOrientationLeft:
			cropRect = bounds;
			cropRect.origin.x = bounds.origin.y;
			cropRect.origin.y = bounds.origin.x;
			break;
			
		case UIImageOrientationRight:
			cropRect = bounds;
			cropRect.origin.x = bounds.origin.y;
			cropRect.origin.y = (self.size.width - bounds.origin.x - bounds.size.width);
            break;
			
		default:
			cropRect = bounds;
			break;
	}
	
	return [self croppedImage:cropRect];
}

- (UIImage *)resizedImage:(CGSize)newSize 
	 interpolationQuality:(CGInterpolationQuality)quality 
			   bitmapInfo:(CGBitmapInfo) bitmapInfo {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality
				   bitmapInfo:bitmapInfo];
}

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality 
			   bitmapInfo:(CGBitmapInfo)bitmapInfo {
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
												space,
												bitmapInfo);
    
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGColorSpaceRelease(space);
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}


- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

- (CGRect)scaleToFit:(CGRect)defaultRect {
    
    CGSize size = self.size;
    CGFloat wScale = defaultRect.size.width / size.width;
    CGFloat hScale = defaultRect.size.height / size.height;
    
    CGFloat scale = MAX(wScale, hScale);
    
    
    return CGRectMake(0,
                      0,
                      ceilf(size.width * scale),
                      ceilf(size.height * scale));
}


@end
