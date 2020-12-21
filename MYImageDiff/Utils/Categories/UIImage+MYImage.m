//
//  UIImage+MYImage.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import "UIImage+MYImage.h"

@implementation UIImage (MYImage)

+ (UIImage *)imageWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = pixelBuffer;
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);

    return image;
}

+ (UIImage *)imageWithMask:(NSString *)maskName
           filledWithColor:(UIColor *)fillColor {
    
    UIImage *maskImage = [UIImage imageNamed:maskName];
    UIGraphicsBeginImageContext(maskImage.size);
    [fillColor set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = CGRectMake(0,
                               0,
                               maskImage.size.width,
                               maskImage.size.height);
    CGContextTranslateCTM(context,
                          0,
                          bounds.size.height);
    CGContextScaleCTM(context,
                      1.0,
                      -1.0);
    CGContextClipToMask(context,
                        bounds,
                        maskImage.CGImage);
    CGContextFillRect(context, bounds);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageWithSize:(CGSize)size
           filledWithColor:(UIColor *)fillColor {
    return [self imageWithSize:size
               filledWithColor:fillColor
                       padding:UIEdgeInsetsZero];
}

+ (UIImage *)imageWithSize:(CGSize)size
           filledWithColor:(UIColor *)fillColor
                   padding:(UIEdgeInsets)inset {
    
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(size);
    [fillColor set];
    CGFloat width = size.width - inset.left - inset.right;
    CGFloat height = size.height - inset.top - inset.bottom;
    CGContextFillRect(UIGraphicsGetCurrentContext(),
                      CGRectMake(inset.left, inset.top, width, height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithSize:(CGSize)size
           filledWithColor:(UIColor *)fillColor
              borderInsets:(UIEdgeInsets)borderInsets
               borderColor:(UIColor *)borderColor {
    
    UIImage *image = nil;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor set];
    CGContextFillRect(context,
                      CGRectMake(0, 0, size.width, size.height));
    [borderColor set];
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokeRect(UIGraphicsGetCurrentContext(),
                        CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)ellipseImageWithSize:(CGSize)size
                  filledWithColor:(UIColor *)filledColor
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor {
    UIImage *image = nil;
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    
    if (filledColor) {
        [filledColor set];
        CGContextFillEllipseInRect(context,
                                   CGRectMake(0, 0, size.width, size.height));
    }
    
    if (borderWidth > 0 && borderColor) {
        [borderColor set];
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokeEllipseInRect(context,
                                     CGRectMake(borderWidth / 2,
                                                borderWidth / 2,
                                                size.width - borderWidth,
                                                size.height - borderWidth));
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithRound:(BOOL)round
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor {
    
    CGSize size = CGSizeMake(self.size.width + borderWidth * 2,
                             self.size.height + borderWidth * 2);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    
    [self drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    if (borderWidth > 0 && borderColor) {
        [borderColor set];
        CGContextSetLineWidth(context, borderWidth);
        CGRect borderRect = CGRectMake(borderWidth / 2,
                                       borderWidth / 2,
                                       size.width - borderWidth,
                                       size.height - borderWidth);
        if (round){
            CGContextStrokeEllipseInRect(context, borderRect);
        } else {
            CGContextStrokeRect(UIGraphicsGetCurrentContext(),
                                borderRect);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)centerResize {
    CGFloat cw = self.size.width / 2.0f;
    CGFloat ch = self.size.height / 2.0f;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(ch, cw, ch, cw)];
}


+ (UIImage *)stretchableImageNamed:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2
                                       topCapHeight:image.size.height / 2];
    return image;
}


@end
