//
//  NSDate+DES.m
//  JZToolKit
//
//  Created by Jack Zhou on 8/14/14.
//  Copyright (c) 2014 JZ. All rights reserved.
//

#import "NSData+DES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
@implementation NSData (DES)
- (NSData *) encryptDESWithKey:(NSString *)key
{
    return[self doCipher:self key:key context:kCCEncrypt];
}
- (NSData *) decryptDESWithKey:(NSString *)key
{
    return[self doCipher:self key:key context:kCCDecrypt];
}

- (NSData *)doCipher:(NSData *)data key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [sKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer
                                    length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

@end
