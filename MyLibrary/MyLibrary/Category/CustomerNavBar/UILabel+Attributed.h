//
//  UILabel+Attributed.h
//  JZ
//
//  Created by jack zhou on 14-3-13.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Attributed)
- (void)text:(NSString *)str color:(UIColor *)color font:(UIFont *)font;
- (void)changeColor;
@end
