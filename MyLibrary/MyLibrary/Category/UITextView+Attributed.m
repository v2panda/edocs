//
//  UITextView+Attributed.m
//  JZToolKit
//
//  Created by jack zhou on 6/5/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "UITextView+Attributed.h"
#import <objc/runtime.h>
@implementation UITextView (Attributed)
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
