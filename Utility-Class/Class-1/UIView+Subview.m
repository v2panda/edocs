//
//  UIView+Subview.m
//  Toolkit
//
//  Created by jack zhou on 12/26/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

- (void)addSubviewWithFadeAnimation:(UIView *)subview
{
    CGFloat finalAlpha = subview.alpha;
    
    subview.alpha = 0.0;
    [self addSubview:subview];
    [UIView animateWithDuration:0.2 animations:^{
        subview.alpha = finalAlpha;
    }];
}

@end
