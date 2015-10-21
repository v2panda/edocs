//
//  ViewController.m
//  PopGestureDemo-1010
//
//  Created by Panda on 15/10/10.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import "ViewController.h"
#import "PDAViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"PUSH3" forState:UIControlStateNormal];
//    [btn setTintColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    btn.size = btn.currentBackgroundImage.size;
    [button addTarget:self action:@selector(BTNCLLL) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
//    UIButton *btn = [[UIButton alloc] init];
//    [btn setBackgroundImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
//    //    btn.size = btn.currentBackgroundImage.size;
////    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
////    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];

}

- (void)BTNCLLL {
    [self.navigationController pushViewController:[PDAViewController new] animated:YES];
}
- (IBAction)BTNCL:(id)sender {
    [self.navigationController pushViewController:[PDAViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
