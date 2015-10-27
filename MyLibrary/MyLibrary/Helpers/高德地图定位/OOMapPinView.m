//
//  OOMapPinView.m
//  OOCity
//
//  Created by nero on 15/2/3.
//  Copyright (c) 2015年 liu jian. All rights reserved.
//

#import "OOMapPinView.h"

@interface OOMapPinView ()
@property (nonatomic, strong) UIImageView *pin;
@property (nonatomic, strong) UIImageView *shadow;
@end

@implementation OOMapPinView


- (void)startAnimation {
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.pin.center = CGPointMake(self.pin.center.x, self.pin.center.y - 15);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             
                             [UIView animateWithDuration:0.15
                                              animations:^{
                                                  self.pin.center = CGPointMake(self.pin.center.x, self.pin.center.y + 15);
                                              }];
                         }
                     }];
}

- (void)clearAnimation {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pin = [UIImageView new];
        self.pin.image = [UIImage imageNamed:@"current-pin"];
        [self addSubview:self.pin];
        self.pin.frame = self.bounds;
        
        self.shadow = [UIImageView new];
        self.shadow.image = [UIImage imageNamed:@"current-shadow"];
        self.shadow.frame = CGRectMake(self.pin.frame.size.width * 0.5 - 4, self.pin.frame.size.height - 2, 8, 3);
        [self addSubview:self.shadow];
        self.clipsToBounds = NO;
    }
    return self;
}

@end
