//
//  MYImageBitmapComparator.h
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/13.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImageBitmapComparator : NSObject

/// 对比两张图像是否相同
/// @param imageA 待对比图片
/// @param imageB 待对比图片
- (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB;

@end

NS_ASSUME_NONNULL_END
