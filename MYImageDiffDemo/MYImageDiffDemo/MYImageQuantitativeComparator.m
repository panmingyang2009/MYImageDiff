//
//  MYImageQuantitativeComparator.m
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

#import "MYImageQuantitativeComparator.h"

#import <CoreImage/CoreImage.h>
#import "MYPixelBinarizationFilter.h"


@interface MYImageQuantitativeComparator ()

@end

@implementation MYImageQuantitativeComparator


+ (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB
   perPixelTolerance:(CGFloat)perPixelTolerance
    overallTolerance:(CGFloat)overallTolerance {
    
    MYImageQuantitativeComparator *comparator = [[self alloc] init];
    comparator.perPixelTolerance = perPixelTolerance;
    comparator.overallTolerance = overallTolerance;
    
    return [comparator compareImage:imageA
                          withImage:imageB];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _perPixelTolerance = 0;
        _overallTolerance = 0;
    }
    return self;
}

- (void)dealloc {
    
}

/// 对比两张图像是否相似。定性分析
/// @param imageA 待对比图片
/// @param imageB 待对比图片
- (BOOL)compareImage:(UIImage *)imageA withImage:(UIImage *)imageB {
    
    CIImage *ciImageA = [[CIImage alloc] initWithImage:imageA];
    CIImage *ciImageB = [[CIImage alloc] initWithImage:imageB];
    
    // MYPixelBinarizationFilter
    MYPixelBinarizationFilter *filter = [MYPixelBinarizationFilter new];
    filter.imageA = ciImageA;
    filter.imageB = ciImageB;
    filter.tolerance = self.perPixelTolerance;
    filter.ignoreAlpha = YES;
    
    CIImage *binarizationImage = filter.outputImage;
    
    // Average
    CIVector *extent = [CIVector vectorWithCGRect:binarizationImage.extent];
    CIFilter *averageFilter = [CIFilter filterWithName:@"CIAreaAverage"];
    [averageFilter setValue:binarizationImage forKey:kCIInputImageKey];
    [averageFilter setValue:extent forKey:kCIInputExtentKey];
    
    CIImage *averageColorImage = averageFilter.outputImage;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 4;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef cgContext = CGBitmapContextCreate(pixelData,
                                                   1,
                                                   1,
                                                   bitsPerComponent,
                                                   bytesPerRow,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CIContext *ciContext = [CIContext contextWithCGContext:cgContext options:nil];
    
    [ciContext drawImage:averageColorImage
                  inRect:CGRectMake(0, 0, 1, 1)
                fromRect:[averageColorImage extent]];
    
    CGContextRelease(cgContext);
    CGColorSpaceRelease(colorSpace);
    
    NSInteger diffPercentage = pixelData[0] / 255.0;
    
    BOOL isSameImage = (diffPercentage <= self.overallTolerance);
    
    return isSameImage;
}

@end
