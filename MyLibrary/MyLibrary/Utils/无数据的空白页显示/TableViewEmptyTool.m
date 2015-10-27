//
//  TableViewEmptyTool.m
//  MyLibrary
//
//  Created by nero on 15/2/28.
//  Copyright (c) 2015年 nero. All rights reserved.
//

#import "TableViewEmptyTool.h"

@implementation TableViewEmptyTool
+ (UIView*)createNoMessageViewWithFrame:(CGRect)frame image:(UIImage*)image text:(NSString*)text {
    UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
    noMessageView.backgroundColor = [UIColor clearColor];
    
    UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
    [carImageView setImage:image];
    [noMessageView addSubview:carImageView];
    
    UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, frame.size.width, 20)];
    noInfoLabel.textAlignment = NSTextAlignmentCenter;
    noInfoLabel.textColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:211.0/255.0];
    noInfoLabel.text = text;
    noInfoLabel.backgroundColor = [UIColor clearColor];
    noInfoLabel.font = [UIFont systemFontOfSize:20];
    [noMessageView addSubview:noInfoLabel];
    
    return noMessageView;
}

- (void)DEMO {
//        CGRect rect = self.shopListView.frame;
//        UIImage* image = [UIImage imageNamed:@"no_message.png"];
//        NSString* text = NSLocalizedString(@"Dear, no information", nil);
//        self.noInfoView = [HJUIUtil createNoMessageViewWithFrame:rect image:image text:text];
//        [self.view addSubview:self.noInfoView];



}
@end
