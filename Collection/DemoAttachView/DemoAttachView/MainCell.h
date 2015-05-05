//
//  MainCell.h
//  DemoAttachView
//
//  Created by 徐臻 on 15/2/10.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell
@property (retain, nonatomic)  UILabel *nameLabel;

@property (retain, nonatomic)  UILabel *IntroductionLabel;

@property (retain, nonatomic)  UILabel *networkLabel;

@property (retain, nonatomic)  UIImageView *Headerphoto;

@property (retain, nonatomic) UIImageView *imageLine;

- (void)setMainCell;
@end
