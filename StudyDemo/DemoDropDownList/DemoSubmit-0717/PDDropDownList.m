//
//  PDDropDownList.m
//  DemoDropDownList-0720
//
//  Created by 徐臻 on 15/7/20.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "PDDropDownList.h"
/**自定义颜色*/
#define RHColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255/255.0]
@implementation PDDropDownList


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self)
    {
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
        
        [self setBackBorder];
    }
    return self;
}

-(void)setUI
{
    //
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    
    //
    self.thirdView = [[UITextField alloc]init];
    [self addSubview:self.thirdView];
    
    //
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认折叠箭头"]];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClicked:)];
    [self addGestureRecognizer:tap];
    
}

- (void)setBackBorder
{
    //给图层添加一个有色边框
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [RHColor(245, 245, 245) CGColor];
}
- (void)btnClicked:(UIButton *)btn
{
    if (self.operation) {
        self.operation();
    }
}

@end

@implementation PDListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self) {
        self = [super initWithFrame:frame style:style];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = RHColor(245, 245, 245);
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context,[RHColor(0, 178, 238) CGColor]);
    
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}


@end
