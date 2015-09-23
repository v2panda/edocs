//
//  PDALineView.h
//  LineViewDemo-0923
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  设置一个view的指定位置的边框

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LineViewType){
    LineViewTypeNone    = 0,
    LineViewTypeTop     = 1,
    LineViewTypeLeft    = 1<<1,
    LineViewTypeBottom  = 1<<2,
    LineViewTypeRight   = 1<<3
};


@interface PDALineView : UIView

- (void)addLineWithLineType:(LineViewType)type;

@end
