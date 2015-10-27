//
//  UIImage+capture.h
//  JYLibrary
//
//  Created by nero on 14-8-13.
//  Copyright (c) 2014年 姜沂. All rights reserved.
//  屏幕截图

#import <UIKit/UIKit.h>

@interface UIImage (capture)
// 返回在那个View里面截的图
+ (instancetype)captureWithView:(UIView *)view;
@end
