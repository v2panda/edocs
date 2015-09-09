//
//  RHEncryptionTool.m
//  RHRedHorse
//
//  Created by panda on 14/12/17.
//  Copyright (c) 2014年 forex. All rights reserved.
//

#import "RHEncryptionTool.h"
#import "Encryption.h"

/**
 加密：1、对Key进行Base64解码 2、加密明文            3、对明文对应的密文进行Base64编码
 解密：1、对Key进行Base64解码 2、对密文进行Base64解码 3、对Base64解码后的密文进行解码
 */

#define baseKey @"SCpqJmtEdSZNNjd4I2Ukcg=="


@implementation RHEncryptionTool
/**大象加密AES 返回String*/
+ (NSString *)AES256EncryptPlaintext:(NSString *)Plaintext
{
    return [NSData base64EncodedStringFrom:[RHEncryptionTool dataAES256EncryptPlaintext:Plaintext]];
}

/**大象加密AES 返回Data*/
+ (NSData *)dataAES256EncryptPlaintext:(NSString *)Plaintext
{
    return [[Plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:[RHEncryptionTool base64Decode]];
}

/**大象解密AES 返回Sting*/
+ (NSString *)AES256DecryptCiphertext:(NSString *)Ciphertext
{
    return [[NSString alloc]initWithData:[RHEncryptionTool dataAES256DecryptCiphertext:Ciphertext] encoding:NSUTF8StringEncoding];
}





/**大象解密AES 返回Data*/
+ (NSData *)dataAES256DecryptCiphertext:(NSString *)Ciphertext
{
    return [[NSData dataWithBase64EncodedString:Ciphertext] AES256DecryptWithKey:[RHEncryptionTool base64Decode]];
}

/**key base64解码*/
+ (NSString *)base64Decode
{
    return [[NSString alloc]initWithData:[NSData dataWithBase64EncodedString:baseKey] encoding:NSUTF8StringEncoding];
}

@end
