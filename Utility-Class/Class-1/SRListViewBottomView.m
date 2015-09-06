//
//  SRListViewBottomView.m
//  StackRoom
//
//  Created by jack zhou on 14-2-26.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import "SRListViewBottomView.h"
@interface SRListViewBottomView ()
@property(nonatomic, strong) UILabel * statusLabel;
@property(nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@end
@implementation SRListViewBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.statusLabel];
        [self addSubview:self.activityIndicatorView];
    }
    return self;
}

+ (instancetype)creatWithSize:(CGSize)size
{
    SRListViewBottomView * v = [[SRListViewBottomView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    return v;
}

-(UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(100, self.frame.size.height - _activityIndicatorView.frame.size.height, 50, 50);
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.backgroundColor = [UIColor clearColor];
    }
    return _statusLabel;
}

-(void)setStatusType:(StatusType)statusType
{
    switch (statusType) {
        case StatusType_Loading:
            self.statusLabel.text = @"       正在加载中...";
            [self.activityIndicatorView startAnimating];
            break;
		case StatusType_NoStart:
            self.statusLabel.text = @"";
			[self.activityIndicatorView stopAnimating];
			break;
        default:
            self.statusLabel.text = @"没有更多了";
            [self.activityIndicatorView stopAnimating];
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
