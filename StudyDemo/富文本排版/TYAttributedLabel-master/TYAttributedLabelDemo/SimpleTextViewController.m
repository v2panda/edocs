//
//  SimpleTextViewController.m
//  TYAttributedLabelDemo
//
//  Created by SunYong on 15/4/17.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "SimpleTextViewController.h"
#import "TYAttributedLabel.h"

@interface SimpleTextViewController ()

@end

@implementation SimpleTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // addAttributedText
    TYAttributedLabel *label1 = [[TYAttributedLabel alloc]init];
//    label1.text = @"\t总有一天你将破蛹而出，成长得比人们期待的还要美丽。但这个过程会很痛，会很辛苦，有时候还会觉得灰心。面对着汹涌而来的现实，觉得自己渺小无力。但这，也是生命的一部分。做好现在你能做的，然后，一切都会好的。我们都将孤独地长大，不要害怕。";
    label1.text = @"\t尊敬的用户，您好：为了给广大用户提供更好的服务，大象理财网定于10月28日晚进行系统维护，届时网站将暂停服务，请避开升级时间段操作。升级时间：2015年10月28日23：00至2015年10月29日02：00升级内容：优化网站性能，修正缺陷。升级给您带来不便，我们深表歉意！感谢您对大象理财的支持，祝您投资顺利！您的意见及建议对我们非常重要，我们热忱期待您的垂询！客服热线： 400-061–1001大象理财网2015年10月28日";
    
    // 文字间隙
    label1.characterSpacing = 2;
    // 文本行间隙
    label1.linesSpacing = 2;
    
    label1.lineBreakMode = kCTLineBreakByTruncatingTail;
    label1.numberOfLines = 0;
    // 文本字体
    label1.font = [UIFont systemFontOfSize:17];
    
    // 设置view的位置和宽，会自动计算高度
    [label1 setFrameWithOrign:CGPointMake(0, 64) Width:CGRectGetWidth(self.view.frame)];
    [self.view addSubview:label1];
    
    
    // appendAttributedText
    TYAttributedLabel *label2 = [[TYAttributedLabel alloc]init];
    label2.frame = CGRectMake(0, CGRectGetMaxY(label1.frame)+10, CGRectGetWidth(self.view.frame), 200);
    [self.view addSubview:label2];
    
    // 追加(添加到最后)文本
    [label2 appendText:@"\t任何值得去的地方，”都没“有捷径；\n"];
    [label2 appendText:@"\t任何值得等待的人，都会迟来一些；\n"];
    [label2 appendText:@"\t任何值得追逐的梦想，都必须在一路艰辛中备受嘲笑。\n"];
    [label2 appendText:@"\t所以，不要怕，不要担心你所追逐的有可能是错的。\n"];
    [label2 appendText:@"\t因为，不被嘲笑的梦想不是梦想。\n"];
    
    // 自适应高度
    [label2 sizeToFit];
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
