//
//  UITableView+EmptyView.m
//  MyLibrary
//
//  Created by nero on 15/2/28.
//  Copyright (c) 2015年 nero. All rights reserved.
//

#import "UITableView+EmptyView.h"
#import <objc/runtime.h>

static char UITableViewEmptyView;
@implementation UITableView (EmptyView)

@dynamic emptyView;

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, &UITableViewEmptyView);
}

- (void)setEmptyView:(UIView *)emptyView {
    [self willChangeValueForKey:@"HJEmptyView"];
    objc_setAssociatedObject(self, &UITableViewEmptyView,emptyView,OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"HJEmptyView"];
}


-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title {
    if (!self.emptyView){
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = [UIColor clearColor];
        
        UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel *noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, frame.size.width, 20)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
        noInfoLabel.text = text;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:20];
        [noMessageView addSubview:noInfoLabel];
        
        [self addSubview:noMessageView];
        
        self.emptyView = noMessageView;
    }
}

@end
