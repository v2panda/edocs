//
//  PDANetworkTool.h
//  MyLibrary
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#warning Reachability 是非arc的  在  build phases  加上编译参数  -fno-objc-arc

@interface PDANetworkTool : NSObject
/**
 *  是否WIFI
 */
+ (BOOL)isEnableWIFI;

/**
 *  是否3G
 */
+ (BOOL)isEnable3G;

@end
