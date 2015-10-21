//
//  PDAImageView.m
//  Demo-0907SB
//
//  Created by Panda on 15/9/9.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "PDAImageView.h"

@implementation PDAImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0?true:false;
}
@end
