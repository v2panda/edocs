//
//  NSMutableDictionary+KeysObjs.m
//  JZToolKit
//
//  Created by jack zhou on 14-4-22.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import "NSMutableDictionary+KeysObjs.h"

@implementation NSMutableDictionary (KeysObjs)
- (void)setObjects:(NSArray *)objs keys:(NSArray *)keys
{
    NSAssert([objs count]==[keys count], @"键值数量不对称");
    for (NSString *key in keys) {
        id obj = [objs objectAtIndex:[keys indexOfObject:key]];
        [self setObject:obj forKey:key];
    }
}
@end
