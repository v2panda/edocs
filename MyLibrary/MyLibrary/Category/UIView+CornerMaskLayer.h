//
//  UIView+CornerMaskLayer.h
//  Meituan
//
//  Created by 臧其龙 on 15/9/18.
//  Copyright (c) 2015年 臧其龙. All rights reserved.
//
//  给View的四个角加圆角

#import <UIKit/UIKit.h>

@interface UIView (CornerMaskLayer)

- (void)addCornerMaskLayerWithRadius:(CGFloat)radius;

@end
