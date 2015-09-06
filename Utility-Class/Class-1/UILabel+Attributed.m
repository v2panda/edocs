//
//  UILabel+Attributed.m
//  JZ
//
//  Created by jack zhou on 14-3-13.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import "UILabel+Attributed.h"
#import <objc/runtime.h>
@implementation UILabel (Attributed)
- (void)text:(NSString *)str color:(UIColor *)color font:(UIFont *)font
{
    if (!str)
        str = self.text;
    if (!color)
        color = self.textColor;
    if (!font)
        font = self.font;
    [self.attributeString setAttributes:@{NSForegroundColorAttributeName:color,
                                     NSFontAttributeName:font}
                             range:[self.text rangeOfString:str]];
}

- (void)changeColor
{
    self.attributedText = self.attributeString;
}

- (NSMutableAttributedString *)attributeString
{
    NSMutableAttributedString *attributeString = objc_getAssociatedObject(self, _cmd);
    if (attributeString && [attributeString.string isEqualToString:self.text]) {
        return attributeString;
    }
    attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    objc_setAssociatedObject(self, _cmd, attributeString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return attributeString;
}
@end
