//
//  NSString+Hash.h
//
//  Created by Tom Corwine on 5/30/12..
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
/**
 *  md5摘要
 */
@property (readonly) NSString *md5String;
/**
 *  <#Description#>
 */
@property (readonly) NSString *sha1String;
/**
 *  <#Description#>
 */
@property (readonly) NSString *sha256String;
/**
 *  <#Description#>
 */
@property (readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end
