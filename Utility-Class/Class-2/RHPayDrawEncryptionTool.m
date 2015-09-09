//
//  RHPayDrawEncryptionTool.m
//  RHRedHorse
//
//  Created by panda on 15/1/20.
//  Copyright (c) 2015年 forex. All rights reserved.
//
#import "Encryption.h"

#import "RHPayDrawEncryptionTool.h"

#define PayDrawKey @"Zi1qJmtGJk02MHghZSRyNQ=="
@implementation RHPayDrawEncryptionTool
/**大象加密AES 返回String*/
+ (NSString *)PayDrawAES256EncryptPlaintext:(NSString *)Plaintext
{
    return [NSData base64EncodedStringFrom:[RHPayDrawEncryptionTool PayDrawDataAES256EncryptPlaintext:Plaintext]];
}

/**大象加密AES 返回Data*/
+ (NSData *)PayDrawDataAES256EncryptPlaintext:(NSString *)Plaintext
{
    return [[Plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:[RHPayDrawEncryptionTool base64Decode]];
}

/**大象解密AES 返回Sting*/
+ (NSString *)PayDrawAES256DecryptCiphertext:(NSString *)Ciphertext
{
    return [[NSString alloc]initWithData:[RHPayDrawEncryptionTool PayDrawDataAES256DecryptCiphertext:Ciphertext] encoding:NSUTF8StringEncoding];
}





/**大象解密AES 返回Data*/
+ (NSData *)PayDrawDataAES256DecryptCiphertext:(NSString *)Ciphertext
{
    return [[NSData dataWithBase64EncodedString:Ciphertext] AES256DecryptWithKey:[RHPayDrawEncryptionTool base64Decode]];
}

/**key base64解码*/
+ (NSString *)base64Decode
{
    return [[NSString alloc]initWithData:[NSData dataWithBase64EncodedString:PayDrawKey] encoding:NSUTF8StringEncoding];
}
@end
