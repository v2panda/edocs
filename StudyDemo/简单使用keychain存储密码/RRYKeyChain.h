//
//  RRYKeyChain.h
//  rry
//
//  Created by 徐臻 on 15/4/3.
//  Copyright (c) 2015年 yunfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#define KEY_PASSWORD  @"com.rry.app.password"
#define KEY_USERNAME_PASSWORD  @"com.rry.app.usernamepassword"
@interface RRYKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
