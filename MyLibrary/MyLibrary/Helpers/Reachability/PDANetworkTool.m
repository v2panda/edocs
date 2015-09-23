//
//  PDANetworkTool.m
//  MyLibrary
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "PDANetworkTool.h"

@implementation PDANetworkTool

// 是否WIFI
+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
