//
//  MYImageCompareViewController.m
//  MYImageDiffDemo
//
//  Created by 潘名扬 on 2020/9/6.
//  Copyright © 2020 MINGYANG PAN. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MYImageCompareViewController.h"
#import <Masonry/Masonry.h>

#import "MYImageComparator.h"


@interface MYImageCompareViewController ()

@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UIImageView *anotherImageView;
@property (nonatomic, strong) UIImageView *diffImageView;

@end

@implementation MYImageCompareViewController

#pragma mark - Lift Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self compareImages];
}

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView *originalImageView = [[UIImageView alloc] init];
    originalImageView.contentMode = UIViewContentModeScaleAspectFit;
    originalImageView.backgroundColor = UIColor.lightGrayColor;
    originalImageView.layer.borderWidth = 1;
    originalImageView.layer.borderColor = UIColor.blackColor.CGColor;
    [self.view addSubview:originalImageView];
    self.originalImageView = originalImageView;
    
    UIImageView *anotherImageView = [[UIImageView alloc] init];
    anotherImageView.contentMode = UIViewContentModeScaleAspectFit;
    anotherImageView.backgroundColor = UIColor.lightGrayColor;
    anotherImageView.layer.borderWidth = 1;
    anotherImageView.layer.borderColor = UIColor.blackColor.CGColor;
    [self.view addSubview:anotherImageView];
    self.anotherImageView = anotherImageView;
    
    UIImageView *diffImageView = [[UIImageView alloc] init];
    diffImageView.contentMode = UIViewContentModeScaleAspectFit;
    diffImageView.backgroundColor = UIColor.lightGrayColor;
    diffImageView.layer.borderWidth = 1;
    diffImageView.layer.borderColor = UIColor.blackColor.CGColor;
    [self.view addSubview:diffImageView];
    self.diffImageView = diffImageView;
    
    CGFloat imageViewHeight = UIScreen.mainScreen.bounds.size.height * 0.4;
    
    [originalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(imageViewHeight);
    }];
    
    [anotherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(imageViewHeight);
        make.left.mas_equalTo(originalImageView.mas_right);
        make.width.mas_equalTo(originalImageView);
    }];
    
    [diffImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(originalImageView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(imageViewHeight);
    }];
}

#pragma mark - Private Methods


- (CGContextRef)createCGContextFromCGImage:(CGImageRef)img {
    size_t width = CGImageGetWidth(img);
    size_t height = CGImageGetHeight(img);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(img);
    size_t bytesPerRow = CGImageGetBytesPerRow(img);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, // Let CG allocate it for us
                                             width,
                                             height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    NSAssert(ctx, @"CGContext creation fail");
    
    return ctx;
}

- (void)compareImages {
    UIImage *originalImage = [UIImage imageNamed:@"github-octocat"];
    UIImage *anotherImage = [UIImage imageNamed:@"github-octocat-edit"];
    self.originalImageView.image = originalImage;
    self.anotherImageView.image = anotherImage;
    
    MYImageComparator *comparator = [MYImageComparator new];
    
    for (int i = 0; i < 50; i++) {
        NSLog(@">>>>> drawing begin");
        CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        
        [comparator compareImage:originalImage withImage:anotherImage];
        
        CFTimeInterval costTime = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@">>>>> drawing done with timecost: %lf", costTime);
    }
    
    // We assume both images are the same size, but it's just a matter of finding the biggest
    // CGRect that contains both image sizes and create the CGContext with that size
    CGRect imageRect = CGRectMake(0, 0,
                                  CGImageGetWidth(originalImage.CGImage),
                                  CGImageGetHeight(originalImage.CGImage));
    // Create our context based on the old image
    CGContextRef ctx = [self createCGContextFromCGImage:originalImage.CGImage];
    
    // Draw the old image with the default (normal) blendmode
    CGContextDrawImage(ctx, imageRect, originalImage.CGImage);
    // Change the blendmode for the remaining drawing operations
    CGContextSetBlendMode(ctx, kCGBlendModeDifference);
    // Draw the new image "on top" of the old one
    CGContextDrawImage(ctx, imageRect, anotherImage.CGImage);
    
    // Grab the composed CGImage
    CGImageRef diffed = CGBitmapContextCreateImage(ctx);
    // Cleanup and return a UIImage
    CGContextRelease(ctx);
    UIImage *diffedImage = [UIImage imageWithCGImage:diffed];
    CGImageRelease(diffed);
    
    self.diffImageView.image = diffedImage;
}

@end
