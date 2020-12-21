#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MYImageDiff.h"
#import "MYPSNRTool.h"
#import "MYPixelBinarizationFilter.h"
#import "MYImageBitmapComparator.h"
#import "MYImageComparator.h"
#import "MYImageQuantitativeComparator.h"
#import "MYImageUniversalComparator.h"
#import "UIColor+MYImage.h"
#import "UIImage+MYImage.h"
#import "UIImage+MYScale.h"
#import "MYImageTool.h"

FOUNDATION_EXPORT double MYImageDiffVersionNumber;
FOUNDATION_EXPORT const unsigned char MYImageDiffVersionString[];

