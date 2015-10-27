//
//  UIView+ClearAlias.m
//  MyLibrary
//
//  Created by Panda on 15/9/24.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "UIView+ClearAlias.h"

@implementation UIView (ClearAlias)

- (void)clearAlias
{
    self.layer.borderWidth = 2 ; // 给图层添加一个边框
    self.layer.borderColor = [UIColor clearColor].CGColor ;//清除颜色 边框就不会显示出来了
    
    // 就会把图层当做是一个bitmap（图片）来渲染  必须设置
    self.layer.shouldRasterize = YES;
    for (UIView *subView in self.subviews) {
        [subView clearAlias];   //给子控件也消除锯齿
    }
    
}

@end
