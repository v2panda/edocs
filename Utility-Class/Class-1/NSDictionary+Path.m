//
//  NSDictionary+Path.m
//  JZTools
//
//  Created by jack zhou on 14-2-24.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import "NSDictionary+Path.h"

@implementation NSDictionary (Path)
- (id)objectForPath:(id)path
{
    id value = self;
    for (NSString * key in [path componentsSeparatedByString:@"."]) {
        value = [value objectForKey:key];
    }
    return value;
}
@end
