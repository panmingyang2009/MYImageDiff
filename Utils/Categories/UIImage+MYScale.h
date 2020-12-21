//
//  UIImage+scale.h
//  TencentMicroblog
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (MYScale)

+ (UIImage *)rotate:(UIImage *)src;

+ (UIImage *)imageByScalingToSize:(UIImage *)sourceImage
                             Size:(CGSize)targetSize;

+ (UIImage *)imageWithImage:(UIImage *)image
            scaledFitToSize:(CGSize)newSize;

-(UIImage *)scaleBySize:(CGSize)size;
-(UIImage *)scaleBySizeNoDouble:(CGSize)size;

- (UIImage *)cropRectBaseOrientation:(CGRect)bounds;

- (UIImage *)resizedImage:(CGSize)newSize 
	 interpolationQuality:(CGInterpolationQuality)quality 
			   bitmapInfo:(CGBitmapInfo) bitmapInfo;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality 
			   bitmapInfo:(CGBitmapInfo)bitmapInfo;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (CGRect)scaleToFit:(CGRect)defaultRect;

@end

