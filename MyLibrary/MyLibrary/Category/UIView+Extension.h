//
//  UIView+Extension.h
//  MyLibrary
//
//  Created by Panda on 15/9/24.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  快捷方式设置view的frame

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@end
