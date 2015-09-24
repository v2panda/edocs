//
//  PDALineView.m
//  LineViewDemo-0923
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "PDALineView.h"
#import "UIColor+Hex.h"

static NSString *const kLineHeColor = @"#D7D7D7";

@implementation PDALineView

- (void)addLineWithLineType:(LineViewType)type
{
    if (type & LineViewTypeTop) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithHexString:kLineHeColor].CGColor;
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeLeft) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithHexString:kLineHeColor].CGColor;
        layer.frame = CGRectMake(0, 0, .5, CGRectGetWidth(self.bounds));
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeBottom) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithHexString:kLineHeColor].CGColor;
        layer.frame = CGRectMake(0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeRight) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithHexString:kLineHeColor].CGColor;
        layer.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, .5, CGRectGetWidth(self.bounds));
        [self.layer addSublayer:layer];
    }
}


@end
