//
//  MYImageUniversalComparator.h
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImageUniversalComparator : NSObject

/// 利用 PSNR 判断两张图像是否相同.
/// 定量分析
/// @param imageA 待对比图片
/// @param imageB 待对比图片
/// @param psnrTolerance PSNR 值容差
+ (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB
       psnrTolerance:(float)psnrTolerance;

/// 计算两张图像之间的峰值信噪比 PSNR
/// @param imageA 待对比图片
/// @param imageB 待对比图片
- (float)psnrForOriginalImage:(UIImage *)imageA
               processedImage:(UIImage *)imageB;

@end

NS_ASSUME_NONNULL_END
