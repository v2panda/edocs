//
//  ViewController.m
//  DoubleSlider
//
//  Created by 徐臻 on 15/5/26.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "ViewController.h"
#import "XFTSRSlider.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    XFTSRSlider *slider = [[XFTSRSlider alloc]initWithFrame:CGRectMake(10, 90, 300, 100) andSliderHeight:50 andDefaultMin:0 andDefaultMax:200 andSliderMin:0 andSliderMax:200 andUnlimated:300];
    [slider setMinButtonImage:[UIImage imageNamed:@"22.png"]];
    [slider setMaxButtonImage:[UIImage imageNamed:@"22.png"]];
    
    [self.view addSubview:slider];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
