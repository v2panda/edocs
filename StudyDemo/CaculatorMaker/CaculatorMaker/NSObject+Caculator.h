//
//  NSObject+Caculator.h
//  
//
//  Created by Panda on 15/9/28.
//
//

#import <Foundation/Foundation.h>
#import "CaculatorMaker.h"

@class CaculatorMaker;
@interface NSObject (Caculator)

+ (int)makeCaculators:(void(^)(CaculatorMaker *maker))caculatorMaker;

@end
