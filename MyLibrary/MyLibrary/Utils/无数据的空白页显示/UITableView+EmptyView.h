//
//  UITableView+EmptyView.h
//  MyLibrary
//
//  Created by nero on 15/2/28.
//  Copyright (c) 2015年 nero. All rights reserved.
// 如果tableView没有数据时显示view
// 原文参加 http://www.jianshu.com/p/20c3ab123a19
#import <UIKit/UIKit.h>

// 这是方法2 推荐使用这种

@interface UITableView (EmptyView)
/**
 *  只读emptyView
 */
@property (nonatomic, strong, readonly) UIView *emptyView;
/**
 *  通过图片和提示创建一个提示view针对tableView有效
 *
 *  @param imageName imageName
 *  @param title     title
 */
-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title;

//demo
//  [self.shopListView.shopListTableView addEmptyViewWithImageName:@"no_message.png" title:@"Dear, no information"];

@end
