//
//  NSString+Paths.m
//  Toolkit
//
//  Created by jack zhou on 12/25/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import "NSString+Paths.h"

@implementation NSString (Paths)

+ (NSString *)cachesPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

+ (NSString *)documentsPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    
    return cachedPath;
}

#pragma mark Temporary Paths

+ (NSString *)temporaryPath
{
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    
    dispatch_once(&onceToken, ^{
        cachedPath = NSTemporaryDirectory();
    });
    
    return cachedPath;
}

+ (NSString *)pathForTemporaryFile
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *tmpPath = [[NSString temporaryPath] stringByAppendingPathComponent:(__bridge NSString *)newUniqueIdString];
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    
    return tmpPath;
}
@end
