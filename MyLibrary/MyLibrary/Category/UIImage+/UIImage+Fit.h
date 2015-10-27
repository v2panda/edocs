//
//  UIImage+Fit.h
//  MyLibrary
//
//  Created by Panda on 15/9/25.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  返回拉伸图片

#import <UIKit/UIKit.h>

@interface UIImage (Fit)

#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName;

- (UIImage *)resizeImage;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
