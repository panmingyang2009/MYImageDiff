//
//  MYImageComparator.m
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/9/6.
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

#import "MYImageComparator.h"
#import <CoreImage/CoreImage.h>


@interface MYImageComparator ()

@end

@implementation MYImageComparator

- (instancetype)init {
    self = [super init];
    if (self) {
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
    
    // diff with Core Image
    CIFilter *diffFilter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
    [diffFilter setValue:ciImageA forKey:kCIInputImageKey];
    [diffFilter setValue:ciImageB forKey:kCIInputBackgroundImageKey];
    
    CIImage *diffImage = [diffFilter valueForKey:kCIOutputImageKey];
    
    // compress
    CIVector *extent = [CIVector vectorWithCGRect:diffImage.extent];
    CIFilter *maximumFilter = [CIFilter filterWithName:@"CIAreaMaximum"];
    [maximumFilter setValue:diffImage forKey:kCIInputImageKey];
    [maximumFilter setValue:extent forKey:kCIInputExtentKey];
    
    CIImage *maximumColorImage = [maximumFilter valueForKey:kCIOutputImageKey];

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
    
    [ciContext drawImage:maximumColorImage
                  inRect:CGRectMake(0, 0, 1, 1)
                fromRect:[maximumColorImage extent]];
    
    CGContextRelease(cgContext);
    CGColorSpaceRelease(colorSpace);
    
    NSInteger maximumFore = MAX(pixelData[0], pixelData[1]);
    NSInteger maximum = MAX(maximumFore, pixelData[2]);
    
    BOOL isSameImage = (maximum == 0);
    
    return isSameImage;
}

@end
