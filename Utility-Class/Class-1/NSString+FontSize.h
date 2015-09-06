//
//  NSString+FontSize.h
//  Toolkit
//
//  Created by jack zhou on 12/26/13.
//  Copyright (c) 2013 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FontSize)
- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width;
@end
