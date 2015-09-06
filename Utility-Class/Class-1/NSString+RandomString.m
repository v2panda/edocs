//
//  NSString+RandString.m
//  JZToolKit
//
//  Created by jack zhou on 5/21/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "NSString+RandomString.h"

@implementation NSString (RandomString)
+ (NSString *)randomStringLength:(int)length
{
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}
@end
