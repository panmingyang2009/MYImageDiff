//
//  MYImageBitmapComparator.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/13.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import "MYImageBitmapComparator.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation MYImageBitmapComparator


- (BOOL)compareImage:(UIImage *)imageA
           withImage:(UIImage *)imageB {
    
    if (!CGSizeEqualToSize(imageA.size, imageB.size)) {
        return NO;
    }

    // Get the image A into data buffer
    CGImageRef imageRefA = [imageA CGImage];
    CGImageRef imageRefB = [imageB CGImage];
    
    NSUInteger widthA = CGImageGetWidth(imageRefA);
    NSUInteger heightA = CGImageGetHeight(imageRefA);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger pixelCount = heightA * widthA;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * widthA;
    NSUInteger bitsPerComponent = 8;
    uint32_t bitmapInfo = (kCGImageAlphaPremultipliedLast |
                           kCGBitmapByteOrder32Big);
    
    unsigned char *rawDataA = (unsigned char*)calloc(pixelCount * 4,
                                                     sizeof(unsigned char));
    unsigned char *rawDataB = (unsigned char*)calloc(pixelCount * 4,
                                                     sizeof(unsigned char));
    
    CGContextRef contextA = CGBitmapContextCreate(rawDataA,
                                                 widthA,
                                                 heightA,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
                                                 
    CGContextRef contextB = CGBitmapContextCreate(rawDataB,
                                                 widthA,
                                                 heightA,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect imageRect = CGRectMake(0, 0, widthA, heightA);
    CGContextDrawImage(contextA,
                       imageRect,
                       imageRefA);
    CGContextDrawImage(contextB,
                       imageRect,
                       imageRefB);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(contextA);

    // RawData contains the image data in the RGBA8888 pixel format.
    BOOL isDifferent = NO;
    for (NSUInteger pixelIndex = 0 ; pixelIndex < pixelCount ; pixelIndex++) {
        NSUInteger byteIndex = pixelIndex * bytesPerPixel;
        unsigned char alphaA = rawDataA[byteIndex + 3];
        unsigned char blueA  = rawDataA[byteIndex + 2];
        unsigned char greenA = rawDataA[byteIndex + 1];
        unsigned char redA   = rawDataA[byteIndex + 0];
        
        unsigned char alphaB = rawDataB[byteIndex + 3];
        unsigned char blueB  = rawDataB[byteIndex + 2];
        unsigned char greenB = rawDataB[byteIndex + 1];
        unsigned char redB   = rawDataB[byteIndex + 0];
        
        if (alphaA != alphaB
            || blueA != blueB
            || greenA != greenB
            || redA != redB) {
            isDifferent = YES;
            break;
        }
    }
    free(rawDataA);
    return isDifferent;
}

@end
