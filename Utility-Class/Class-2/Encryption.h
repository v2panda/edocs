//
//  Encryption.h
//
//  Created by wu.zhe on 14/11/17.
//  Copyright (c) 2014年  All rights reserved.
//  AES加密

#import <Foundation/Foundation.h>

#define Key (@"SCpqJmtEdSZNNjd4I2Ukcg==")


@interface NSData (RHEncryption)

#pragma mark －AES
/**加密*/
- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
/**解谜*/
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密


#pragma mark Base64
/**追加64编码*/
- (NSString *)newStringInBase64FromData;            //追加64编码
/**同上64编码*/
+ (NSString*)base64encode:(NSString*)str;           //同上64编码


/**base64格式字符串转换为文本数据*/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
/**文本数据转换为base64格式字符串*/
+ (NSString *)base64EncodedStringFrom:(NSData *)data;



@end
