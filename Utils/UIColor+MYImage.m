//
//  UIColor+MYImage.m
//  MYImageDiff
//
//  Created by 潘名扬 on 2020/12/13.
//

#import "UIColor+MYImage.h"

@implementation UIColor (MYImage)

- (BOOL)compareWithColor:(UIColor *)otherColor {
    if (!otherColor) {
        return NO;
    }
    
    CGFloat currentAlpha = 0;
    CGFloat currentBlue = 0;
    CGFloat currentGreen = 0;
    CGFloat currentRed = 0;
    
    CGFloat othersAlpha = 0;
    CGFloat othersBlue = 0;
    CGFloat othersGreen = 0;
    CGFloat othersRed = 0;
    
    [self getRed:&currentRed
           green:&currentGreen
            blue:&currentBlue
           alpha:&currentAlpha];
           
    [otherColor getRed:&othersRed
                 green:&othersGreen
                  blue:&othersBlue
                 alpha:&othersAlpha];
    
    if (currentRed != othersRed ||
        currentGreen != othersGreen ||
        currentBlue != othersBlue ||
        currentAlpha != othersAlpha) {
        return NO;
    }
    
    return YES;
}

@end
