//
//  RHPayDrawEncryptionTool.h
//  RHRedHorse
//
//  Created by 吴哲 on 15/1/20.
//  Copyright (c) 2015年 forex. All rights reserved.
//  支付取现加密 专用

#import <Foundation/Foundation.h>

@interface RHPayDrawEncryptionTool : NSObject
/**大象加密AES 返回String*/
+ (NSString *)PayDrawAES256EncryptPlaintext:(NSString *)Plaintext;

/**大象加密AES 返回Data*/
+ (NSData *)PayDrawDataAES256EncryptPlaintext:(NSString *)Plaintext;

/**大象解密AES 返回Sting*/
+ (NSString *)PayDrawAES256DecryptCiphertext:(NSString *)Ciphertext;

/**大象解密AES 返回Data*/
+ (NSData *)PayDrawDataAES256DecryptCiphertext:(NSString *)Ciphertext;
@end
