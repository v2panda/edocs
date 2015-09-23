//
//  PDATextView.h
//  MyLibrary
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//
//  自定义带有placeholder的textView

#import <UIKit/UIKit.h>

@interface PDATextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
