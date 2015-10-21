//
//  PDANav.m
//  PopGestureDemo-1010
//
//  Created by Panda on 15/10/10.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import "PDANav.h"


@interface TestDelegate :NSObject

@end

@implementation TestDelegate



@end




@interface PDANav ()

@end

@implementation PDANav

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        // 2.覆盖返回按钮
        // 只要覆盖了返回按钮, 系统自带的拖拽返回上一级的功能就会失效
        viewController.navigationItem.leftBarButtonItem = [self itemWithImage:@"返回箭头" highImage:@"返回箭头" target:self action:@selector(back)];
        
    }
    
    // 第一次(根控制器)不需要隐藏工具条
    [super pushViewController:viewController animated:animated];
    
}


- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
