//
//  NSDictionary+Path.h
//  JZTools
//
//  Created by jack zhou on 14-2-24.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Path)
/**
 *  根据路径获取value
 *
 *  @param path 路径(xxx.yyy.sss)以"."做为分割符
 *
 *  @return value
 */
- (id)objectForPath:(id)path;
@end
