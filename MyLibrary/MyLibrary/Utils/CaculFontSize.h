//
//  CaculFontSize.h
//  MyLibrary
//
//  Created by nero on 14/12/15.
//  Copyright (c) 2014年 nero. All rights reserved.
//  计算文字长度

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CaculFontSize : NSObject
/**
 *  计算文字长度   有极限长度
 *
 *  @param text 文字
 *  @param font 字体
 *  @param maxW 最大长度
 *
 *  @return 长度
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;
/**
 *  计算文字长度
 *
 *  @param text 文字
 *  @param font 字体
 *
 *  @return 长度
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
@end
