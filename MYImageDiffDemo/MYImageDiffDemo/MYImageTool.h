//
//  MYImageTool.h
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/12/20.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImageTool : NSObject

+ (void)readRawDataFromUIImage:(UIImage *)image
                    outRawData:(unsigned char *)rawData;

@end

NS_ASSUME_NONNULL_END
