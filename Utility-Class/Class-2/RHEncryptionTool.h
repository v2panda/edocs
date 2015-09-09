//
//  RHEncryptionTool.h
//  RHRedHorse
//
//  Created by panda on 14/12/17.
//  Copyright (c) 2014年 forex. All rights reserved.
//  大象数据加密AES128 工具类

#import <Foundation/Foundation.h>

@interface RHEncryptionTool : NSObject


/**大象加密AES 返回String*/
+ (NSString *)AES256EncryptPlaintext:(NSString *)Plaintext;

/**大象加密AES 返回Data*/
+ (NSData *)dataAES256EncryptPlaintext:(NSString *)Plaintext;

/**大象解密AES 返回Sting*/
+ (NSString *)AES256DecryptCiphertext:(NSString *)Ciphertext;

/**大象解密AES 返回Data*/
+ (NSData *)dataAES256DecryptCiphertext:(NSString *)Ciphertext;

@end
