//
//  NSString+Empty.m
//  DDToolKit
//
//  Created by Mr"OK on 14-8-19.
//  Copyright (c) 2014年 hzdracom. All rights reserved.
//

#import "NSString+Empty.h"

@implementation NSString (Empty)

- (BOOL)isEmpty{
    if (self) {
        if ([[self class] isSubclassOfClass:[NSNull class]]) {
            return YES;
        }else if (self.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

@end
