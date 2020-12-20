//
//  MYImageTool.m
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import "MYImageTool.h"
#import <UIKit/UIKit.h>

@implementation MYImageTool

+ (void)readRawDataFromUIImage:(UIImage *)image
                    outRawData:(unsigned char *)rawData {
    
    // Get the image into data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    uint32_t bitmapInfo = (kCGImageAlphaPremultipliedLast |
                           kCGBitmapByteOrder32Big);
    
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect imageRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context,
                       imageRect,
                       imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
}

@end
