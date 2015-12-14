//
//  main.m
//  CaculatorMaker
//
//  Created by Panda on 15/12/14.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Caculator.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        int result = [NSObject makeCaculators:^(CaculatorMaker *maker) {
            maker.add(1).add(1).add(3).multi(3).sub(5).divide(2);
            
        }];
        NSLog(@"result is : %d",result);
    }
    return 0;
}
