//
//  PDAUserDefaults.m
//  MyLibrary
//
//  Created by Panda on 15/10/26.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import "PDAUserDefaults.h"

@implementation PDAUserDefaults

+ (void)pd_setValue:(id)value forKey:(NSString *)key
{
    if (value && ![value isEqual:[NSNull null]] && key && ![key isEqual:[NSNull null]]) {
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id)pd_getValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
