//
//  PDAUserDefaults.h
//  MyLibrary
//
//  Created by Panda on 15/10/26.
//  Copyright © 2015年 Panda. All rights reserved.
//
//  自定义UserDefaults存储类

#import <Foundation/Foundation.h>

@interface PDAUserDefaults : NSObject

+ (void)pd_setValue:(id)value forKey:(NSString *)key;
+ (id)pd_getValueForKey:(NSString *)key;

@end
