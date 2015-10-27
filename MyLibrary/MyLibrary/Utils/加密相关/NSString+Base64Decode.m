//
//  NSString+Base64Decode.m
//  JZToolKit
//
//  Created by Jack Zhou on 8/15/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "NSString+Base64Decode.h"
#import "Base64.h"
@implementation NSString (Base64Decode)
- (NSData *)base64DecodedWithData
{
    return [self base64DecodedData];
}
@end
