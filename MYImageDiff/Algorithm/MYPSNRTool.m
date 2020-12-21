//
//  MYPSNRTool.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import "MYPSNRTool.h"
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Accelerate/Accelerate.h>
#import <math.h>


@implementation MYPSNRTool

+ (float)psnrForOriginalImage:(UIImage *)imageA
               processedImage:(UIImage *)imageB {
    
    if (!CGSizeEqualToSize(imageA.size, imageB.size)) {
        return NO;
    }

    // Get the image A into data buffer
    CGImageRef imageRefA = [imageA CGImage];
    CGImageRef imageRefB = [imageB CGImage];

    CFDataRef pixelDataA = CGDataProviderCopyData(CGImageGetDataProvider(imageRefA));
    const UInt8 *pixelBytesA = CFDataGetBytePtr(pixelDataA);
    CFDataRef pixelDataB = CGDataProviderCopyData(CGImageGetDataProvider(imageRefB));
    const UInt8 *pixelBytesB = CFDataGetBytePtr(pixelDataB);
    
    NSUInteger widthA = CGImageGetWidth(imageRefA);
    NSUInteger heightA = CGImageGetHeight(imageRefA);
    NSUInteger pixelCount = heightA * widthA;
    
    // Extract red channel to Vector
    float *redVectorA = (float *)calloc(pixelCount, sizeof(float));
    float *redVectorB = (float *)calloc(pixelCount, sizeof(float));
    
    vDSP_vfltu8(pixelBytesA,
                4,
                redVectorA,
                1,
                pixelCount);
    
    vDSP_vfltu8(pixelBytesB,
                4,
                redVectorB,
                1,
                pixelCount);
    
    // Subtract Vector A with Vector B
    float *redVectorSub = (float *)calloc(pixelCount, sizeof(float));
    
    vDSP_vsub(redVectorB,
              1,
              redVectorA,
              1,
              redVectorSub,
              1,
              pixelCount);
    
    // Calculate MSE
    // https://developer.apple.com/documentation/accelerate/1450014-vdsp_measqv?language=objc
    float mse;
    vDSP_measqv(redVectorSub,
                1,
                &mse,
                pixelCount);
    
    // Calculate PSNR
    float psnr = 20 * log10f((255.0 / sqrtf(mse)));
        
    free(redVectorSub);
    free(redVectorA);
    free(redVectorB);
    CFRelease(pixelDataA);
    CFRelease(pixelDataB);
    
    return psnr;
}


@end
