//
//  NSString+FontSize.m
//  Toolkit
//
//  Created by jack zhou on 12/26/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import "NSString+FontSize.h"

@implementation NSString (FontSize)
- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width {
    CGRect bounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return bounds.size;
}

@end
