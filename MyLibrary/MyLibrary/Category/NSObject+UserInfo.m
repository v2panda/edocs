//
//  NSObject+UserInfo.m
//  Toolkit
//
//  Created by jack zhou on 12/25/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import "NSObject+UserInfo.h"

#import <objc/runtime.h>
@implementation NSObject (UserInfo)

const char *cObjectUserInfo;

- (void)setObjectUserInfo:(id)objectUserInfo
{
    objc_setAssociatedObject(self, cObjectUserInfo, objectUserInfo, OBJC_ASSOCIATION_RETAIN);
}

- (id)objectUserInfo
{
    return objc_getAssociatedObject(self, cObjectUserInfo);
}

@end