//
//  UITextView+Attributed.h
//  JZToolKit
//
//  Created by jack zhou on 6/5/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Attributed)
- (void)text:(NSString *)str color:(UIColor *)color font:(UIFont *)font;
- (void)changeColor;
@end
