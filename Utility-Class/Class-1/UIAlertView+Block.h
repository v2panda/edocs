//
//  UIAlertView+Block.h
//  DDToolKit
//
//  Created by Mr"OK on 14/11/21.
//  Copyright (c) 2014年 hzdracom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Blcok)

- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

@end
