//
//  UITabBar+UnifiableStyle.h
//  ScottishFold
//
//  Created by jack zhou on 5/22/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (UnifiableStyle)
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@end
