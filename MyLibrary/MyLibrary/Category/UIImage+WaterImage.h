//
//  UIImage+WaterImage.h
//  MyLibrary
//
//  Created by Panda on 15/9/24.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  返回一个带有水印的图片

#import <UIKit/UIKit.h>

@interface UIImage (WaterImage)

/**
 *  打水印
 *
 *  @param bg   背景图片
 *  @param logo 右下角的水印图片
 */
+ (instancetype)waterImageWithBg:(NSString *)bg logo:(NSString *)logo;

@end
