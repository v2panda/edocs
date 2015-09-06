//
//  NSString+Paths.h
//  Toolkit
//
//  Created by jack zhou on 12/25/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Paths)

/** Determines the path to the Library/Caches folder in the current application's sandbox.
 
 The return value is cached on the first call.
 
 @return The path to the app's Caches folder.
 */
+ (NSString *)cachesPath;


/** Determines the path to the Documents folder in the current application's sandbox.
 
 The return value is cached on the first call.
 
 @return The path to the app's Documents folder.
 */
+ (NSString *)documentsPath;

/**-------------------------------------------------------------------------------------
 @name Getting Temporary Paths
 ---------------------------------------------------------------------------------------
 */

/** Determines the path for temporary files in the current application's sandbox.
 
 The return value is cached on the first call. This value is different in Simulator than on the actual device. In Simulator you get a reference to /tmp wheras on iOS devices it is a special folder inside the application folder.
 
 @return The path to the app's folder for temporary files.
 */
+ (NSString *)temporaryPath;


/** Creates a unique filename that can be used for one temporary file or folder.
 
 The returned string is different on every call. It is created by combining the result from temporaryPath with a unique UUID.
 
 @return The generated temporary path.
 */
+ (NSString *)pathForTemporaryFile;

@end
