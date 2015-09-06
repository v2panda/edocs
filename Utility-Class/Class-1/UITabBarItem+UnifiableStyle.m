//
//  UITabBar+UnifiableStyle.m
//  ScottishFold
//
//  Created by jack zhou on 5/22/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "UITabBarItem+UnifiableStyle.h"
#import "UtilsMacro.h"

@implementation UITabBarItem (UnifiableStyle)
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UITabBarItem *tabBarItem = nil;
    if (iOS7) {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    }else{
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:nil tag:0];
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:image];
    }
    return tabBarItem;
}
@end
