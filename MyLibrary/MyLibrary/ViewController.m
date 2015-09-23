//
//  ViewController.m
//  MyLibrary
//
//  Created by Panda on 15/9/23.
//  Copyright (c) 2015年 Panda. All rights reserved.
//

#import "ViewController.h"
#import "PDATextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"test");
//    ALERTLog(@"test");
    ALLLog(@"Test");
    LogFunc
    LogFrame(self.view);
    LogSubViews(self.view);
    
    NSLog(@"%d",[PDANetworkTool isEnable3G]);
    NSLog(@"%d",[PDANetworkTool isEnableWIFI]);
    
    PDATextView *textView = [[PDATextView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    textView.placeholder = @"hehe";
    textView.placeholderColor = [UIColor yellowColor];
    textView.backgroundColor = [UIColor blackColor];
    textView.textColor = [UIColor redColor];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
