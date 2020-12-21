//
//  MYPixelBinarizationFilter.h
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/2/28.
//  Copyright © 2020 Punmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPixelBinarizationFilter : CIFilter

/// 待对比图像A
@property (nonatomic, strong, nullable) CIImage *imageA;
/// 待对比图像B
@property (nonatomic, strong, nullable) CIImage *imageB;

/// 容差值
/// @discussion 当某个颜色分量的差异超过容差值，则认为该颜色分量不同
@property (nonatomic, assign) NSUInteger tolerance;

@property (nonatomic, assign) BOOL ignoreAlpha;

@end

NS_ASSUME_NONNULL_END
