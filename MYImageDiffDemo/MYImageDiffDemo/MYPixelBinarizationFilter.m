//
//  MYPixelBinarizationFilter.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/2/28.
//  Copyright © 2020 Punmy. All rights reserved.
//

#import "MYPixelBinarizationFilter.h"
#import <CoreImage/CoreImage.h>

@implementation MYPixelBinarizationFilter

static CIKernel *customKernel = nil;

- (instancetype)init {
    self = [super init];
    if (self &&
        customKernel == nil) {
        
        NSBundle *bundle = [NSBundle bundleForClass: [self class]];
        NSURL *kernelURL = [bundle URLForResource:@"MYPixelBinarization"
                                    withExtension:@"cikernel"];
        
        NSError *error;
        NSString *kernelCode = [NSString stringWithContentsOfURL:kernelURL
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
        if (kernelCode == nil) {
            NSLog(@"Error loading kernel code string in %@\n%@",
                  NSStringFromSelector(_cmd),
                  [error localizedDescription]);
            abort();
        }
        
#if DEBUG
        NSMutableArray *messageLog = [NSMutableArray array];
        SEL logSelector = @selector(kernelsWithString:messageLog:);
        NSArray *kernels = [[CIKernel class] performSelector:logSelector
                                                  withObject:kernelCode
                                                  withObject:messageLog];
        if (messageLog.count > 0) {
            NSLog(@"Error: %@", messageLog.description);
        }
#else
        NSArray *kernels = [CIKernel kernelsWithString:kernelCode];
#endif
        customKernel = kernels.firstObject;
    }
    
    return self;
}

- (CIImage *)outputImage {
    CGRect dod = self.imageA.extent;
    NSUInteger tolerance = self.tolerance + 1;  // 将 < 转为 <=
    NSArray *arguments = @[self.imageA,
                           self.imageB,
                           @(tolerance / 255.0)];
    CIKernelROICallback roiCallback = ^CGRect(int index, CGRect destRect) {
        return destRect;
    };
    
    return [customKernel applyWithExtent:dod
                             roiCallback:roiCallback
                               arguments:arguments];
}

@end
