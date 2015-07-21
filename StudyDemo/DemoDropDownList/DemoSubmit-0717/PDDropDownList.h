//
//  PDDropDownList.h
//  DemoDropDownList-0720
//
//  Created by 徐臻 on 15/7/20.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//
//  仿网页下拉选择框

#import <UIKit/UIKit.h>

@interface PDDropDownList : UIView

//标题label
@property (nonatomic ,strong)UILabel *titleLabel;
//是否显示textField
@property (nonatomic ,strong)UITextField *thirdView;
//右边imageView
@property (nonatomic ,strong)UIImageView *imageView;

//回调block
@property (nonatomic ,strong) void (^operation)();

@end


@interface PDListTableView : UITableView

@end