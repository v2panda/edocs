//
//  UIAlertView+Block.m
//  DDToolKit
//
//  Created by Mr"OK on 14/11/21.
//  Copyright (c) 2014年 hzdracom. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

@implementation UIAlertView (Block)

static char key;

- (void)showAlertViewWithCompleteBlock:(CompleteBlock)block
{
    if (block) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    CompleteBlock block = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

@end
