//
//  MYPSNRTool.h
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPSNRTool : NSObject

+ (float)psnrForOriginalImage:(UIImage *)imageA
               processedImage:(UIImage *)imageB;

@end

NS_ASSUME_NONNULL_END
