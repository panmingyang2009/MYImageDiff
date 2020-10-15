//
//  MYImageComparator.m
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/9/6.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
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
    NSInteger maximumBack = MAX(pixelData[2], pixelData[3]);
    NSInteger maximum = MAX(maximumFore, maximumBack);
    
    return maximum == 0;
}

@end
