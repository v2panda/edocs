//
//  UIImage+Color.h
//  MyLibrary
//
//  Created by Panda on 15/9/25.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  获取图片中某个点的颜色

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point;
@end
