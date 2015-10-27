//
//  TableViewEmptyTool.h
//  MyLibrary
//
//  Created by nero on 15/2/28.
//  Copyright (c) 2015年 nero. All rights reserved.
// 如果tableView没有数据时显示view
// 原文参加 http://www.jianshu.com/p/20c3ab123a19
// 这是方法1
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TableViewEmptyTool : NSObject
/**
 *  创建一个提示也米娜
 *
 *  @param frame frame
 *  @param image image
 *  @param text  title
 *
 *  @return 提示view
 */
+ (UIView*)createNoMessageViewWithFrame:(CGRect)frame image:(UIImage*)image text:(NSString*)text;
-  (void)DEMO;
@end
