//
//  CaculFontSize.m
//  MyLibrary
//
//  Created by nero on 14/12/15.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "CaculFontSize.h"
@implementation CaculFontSize
#pragma mark -
#pragma mark - 计算文字宽度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}
@end
