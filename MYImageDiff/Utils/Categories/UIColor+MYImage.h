//
//  UIColor+MYImage.h
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MYImage)

/// 16 进制颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/// 比较颜色是否相同
/// @param otherColor 另一个颜色
- (BOOL)compareWithColor:(UIColor *)otherColor;

/// 转为 int 值
- (int)intValue;

@end

NS_ASSUME_NONNULL_END
