//
//  CaculatorMaker.h
//  链式编程CaculatorMaker-0928
//
//  Created by Panda on 15/9/28.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculatorMaker : NSObject

@property (nonatomic, assign) int result;

//  加法
- (CaculatorMaker *(^)(int))add;

- (CaculatorMaker *(^)(int))sub;
- (CaculatorMaker *(^)(int))multi;
- (CaculatorMaker *(^)(int))divide;

@end
