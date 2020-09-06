//
//  MYImageComparator.h
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/9/6.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYImageComparator : NSObject

- (BOOL)compareImage:(UIImage *)imageA withImage:(UIImage *)imageB;

@end

NS_ASSUME_NONNULL_END
