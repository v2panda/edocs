//
//  PDASafariNavbar.m
//  Demo-0907SB
//
//  Created by Panda on 15/9/14.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "PDASafariNavbar.h"

@implementation PDASafariNavbar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBar];
    }
    return self;
}

- (void)configureBar
{
    // Configure bar appearence
    self.maximumBarHeight = 105.0;
    self.minimumBarHeight = 20.0;
    self.backgroundColor = [UIColor colorWithRed:0.31 green:0.42 blue:0.64 alpha:1];
    self.clipsToBounds = YES;
    
    
    
    
    
}
@end
