//
//  MYImageQuantitativeComparator.h
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/12/13.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface MYImageQuantitativeComparator : NSObject

/// 色值容差
/// @discussion 表示单像素点的色值允许偏差的比例，
/// 范围 0.0~1.0，默认值 0
@property (nonatomic, assign) CGFloat perPixelTolerance;

/// 总体像素点容差
/// @discussion 表示允许多少比例的像素点有差异，
/// 范围 0.0~1.0，默认值 0
@property (nonatomic, assign) CGFloat overallTolerance;


/// 对比两张图像是否相似。定量分析
/// @param imageA 待对比图片
/// @param imageB 待对比图片
/// @param perPixelTolerance 值容差
/// @param overallTolerance 总体像素点容差
+ (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB
   perPixelTolerance:(CGFloat)perPixelTolerance
    overallTolerance:(CGFloat)overallTolerance;


/// 对比两张图像是否相似。定量分析
/// @param imageA 待对比图片
/// @param imageB 待对比图片
- (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB;

@end


NS_ASSUME_NONNULL_END
