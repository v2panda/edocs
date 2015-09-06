//
//  NSString+DES.h
//  JZTools
//
//  Created by jack zhou on 14-2-21.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)
- (NSString *) encryptDESWithKey:(NSString *)key;
- (NSString *) decryptDESWithKey:(NSString *)key;
@end
