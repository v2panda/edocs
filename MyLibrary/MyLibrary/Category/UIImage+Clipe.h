//
//  UIImage+Clipe.h
//  MyLibrary
//
//  Created by Panda on 15/9/25.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  头像裁剪

#import <UIKit/UIKit.h>

@interface UIImage (Clipe)

/*
 *  Parame  @Name 图片名称
 *  parame  @borderWidth 圆框宽度
 *  parame  @borderColor 圆框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
