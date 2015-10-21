//
//  ViewController.m
//  链式编程CaculatorMaker-0928
//
//  Created by Panda on 15/9/28.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Caculator.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSCache *_cacahe;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    int result = [NSObject makeCaculators:^(CaculatorMaker *maker) {
        maker.add(1).add(1).add(3).multi(3).sub(5).divide(2);

    }];
    NSLog(@"result : %d",result);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
