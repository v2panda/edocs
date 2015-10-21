//
//  CaculatorMaker.m
//  链式编程CaculatorMaker-0928
//
//  Created by Panda on 15/9/28.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

//  加法
- (CaculatorMaker *(^)(int))add
{
    return ^id(int x) {
        self.result += x;
        return self;
    };
}

- (CaculatorMaker *(^)(int))sub
{
    return ^id(int x) {
        self.result -= x ;
        return self;
    };
}
- (CaculatorMaker *(^)(int))multi
{
    return ^id(int x) {
        self.result *= x ;
        return self;
    };
}
- (CaculatorMaker *(^)(int))divide
{
    return ^id(int x) {
        self.result /= x ;
        return self;
    };
}

@end
