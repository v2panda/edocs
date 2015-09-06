//
//  NSDate+DES.h
//  JZToolKit
//
//  Created by Jack Zhou on 8/14/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DES)
- (NSData *) encryptDESWithKey:(NSString *)key;
- (NSData *) decryptDESWithKey:(NSString *)key;
@end
