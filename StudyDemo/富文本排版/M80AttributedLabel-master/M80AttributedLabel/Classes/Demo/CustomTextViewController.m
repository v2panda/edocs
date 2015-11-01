//
//  CustomTextViewController.m
//  M80AttributedLabel
//
//  Created by amao on 5/21/14.
//  Copyright (c) 2014 www.xiangwangfeng.com. All rights reserved.
//

#import "CustomTextViewController.h"
#import "M80AttributedLabel.h"

@interface CustomTextViewController ()

@end

@implementation CustomTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *fonts = @[[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:13],[UIFont systemFontOfSize:17],[UIFont systemFontOfSize:25]];
    NSArray *colors= @[UIColorFromRGB(0x000000),UIColorFromRGB(0x0000FF),UIColorFromRGB(0x00FF00),UIColorFromRGB(0xFF0000)];
    
    
    M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    
//    NSString *plainText = @"The release of iOS 7 brings a lot of new tools to the table for developers.";
    
    NSString *plainText = @"尊敬的用户，您好:\n为了给广大用户提供更好的服务，大象理财网定于10月28日晚进行系统维护，届时网站将暂停服务，请避开升级时间段操作。\n升级时间：2015年10月28日23：00至2015年10月29日02：00\n升级内容：优化网站性能，修正缺陷。\n升级给您带来不便，我们深表歉意！\n感谢您对大象理财的支持，祝您投资顺利！\n您的意见及建议对我们非常重要，我们热忱期待您的垂询！\n客服热线： 400-061–1001 ";
    
    NSArray *components = [plainText componentsSeparatedByString:@"\n"];
    for (NSString *text in components)
    {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
        NSInteger index = arc4random() % 4;
        [attributedText setFont:[fonts objectAtIndex:index]];
        [attributedText setTextColor:[colors objectAtIndex:index]];
        
        [label appendAttributedText:attributedText];
        [label appendText:@" "];
    }
    label.frame     = CGRectInset(self.view.bounds,20,20);
    
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
