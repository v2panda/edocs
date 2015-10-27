//
//  NSString+QRCode.h
//  JYLibrary
//
//  Created by nero on 14-10-22.
//  Copyright (c) 2014年 姜沂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (QRCode)
/**
 * 返回当前字符串对应的二维码图像
 *
 * 二维码的实现是将字符串传递给滤镜，滤镜直接转换生成二维码图片
 */
- (UIImage *)createQRCode;

@end
