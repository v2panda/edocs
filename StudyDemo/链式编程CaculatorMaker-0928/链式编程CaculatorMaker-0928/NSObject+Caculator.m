//
//  NSObject+Caculator.m
//  
//
//  Created by Panda on 15/9/28.
//
//

#import "NSObject+Caculator.h"

@implementation NSObject (Caculator)

+ (int)makeCaculators:(void(^)(CaculatorMaker *maker))caculatorMaker
{
    CaculatorMaker *maker = [[CaculatorMaker alloc]init];
    caculatorMaker(maker);
    
    return maker.result;
}
@end
