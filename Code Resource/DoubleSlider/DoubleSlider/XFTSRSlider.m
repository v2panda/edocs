//
//  SRSlider.m
//  Test
//
//  Created by WangPan on 15/4/2.
//  Copyright (c) 2015年 WangPan. All rights reserved.
//

#import "XFTSRSlider.h"
#define Duration 0.2
#define SLSection 45
#define Wuxian @"不限"
#define HEXCOLOR(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]
@interface XFTSRSlider()
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIView *midView;
@property (nonatomic ,strong) UIView *sliderView;
@property (nonatomic ,strong) UIButton *minBtn;
@property (nonatomic ,strong) UIButton *maxBtn;
@property (nonatomic ,strong) UILabel *minLab;
@property (nonatomic ,strong) UILabel *maxLab;
@property (nonatomic ,strong) UIImageView *minImage;
@property (nonatomic ,strong) UIImageView *maxImage;
@property (nonatomic ,assign) CGFloat btnRadius;
@property (nonatomic ,assign) CGFloat realSection;
@property (nonatomic ,assign) CGFloat curMax;
@property (nonatomic ,assign) CGFloat curMin;
@property (nonatomic ,assign) CGFloat sliderMin;
@property (nonatomic ,assign) CGFloat sliderMax;
@property (nonatomic ,assign) CGFloat unlimited;
@property (nonatomic ,assign) CGFloat sHeight;

@property (nonatomic ,assign) BOOL isLeft;
@end

@implementation XFTSRSlider
-(id)initWithFrame:(CGRect)frame andSliderHeight:(CGFloat)SliderHeight andDefaultMin:(CGFloat)dMin andDefaultMax:(CGFloat)dMax andSliderMin:(CGFloat)sMin andSliderMax:(CGFloat)sMax andUnlimated:(CGFloat)unlimated{
    self = [super initWithFrame:frame];
    if (self) {

        _sliderMax = sMax;
        _sliderMin = sMin;
        _unlimited = unlimated;
        _curMin = dMin;
        _curMax = dMax;
        
        self.sHeight = SliderHeight;
        self.btnRadius = SliderHeight / 4.0;
        self.realSection = frame.size.width - SliderHeight / 2 * 3.5;
        
        UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, SliderHeight)];
        self.sliderView = sView;
        [self addSubview:self.sliderView];
        
        UIView *bkLine  = [[UIView alloc] initWithFrame:CGRectMake(self.btnRadius * 2, SliderHeight  / 2.0 - 1, frame.size.width  - self.btnRadius * 3, 2)];
        self.lineView = bkLine;
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self.sliderView addSubview:self.lineView];
        
        UIView *midLine = [[UIView alloc] init];
        if (dMax <= sMax) {
            midLine.frame = CGRectMake(dMin /(sMax- sMin) * self.realSection + self.btnRadius * 2, SliderHeight / 2 - 1,(dMax - dMin) /  (sMax - sMin) * self.realSection, 2);
        }else{
            CGFloat minLength = dMin /(sMax- sMin) * self.realSection  + self.btnRadius * 3;
             midLine.frame = CGRectMake(minLength, SliderHeight / 2 - 1,frame.size.width - minLength - self.btnRadius, 2);
        }
        self.midView = midLine;
        self.midView.backgroundColor = [UIColor grayColor];
        [self.sliderView addSubview: self.midView];
        
        UIButton *minView = [[UIButton alloc] initWithFrame:CGRectMake(dMin /(sMax- sMin) * self.realSection, 0, SliderHeight, SliderHeight)];
        self.minBtn = minView;
        self.minBtn.backgroundColor = [UIColor orangeColor];
        self.minBtn.layer.cornerRadius = self.btnRadius;
        self.minBtn.clipsToBounds = YES;
        UIPanGestureRecognizer *minPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(minPanChange:)];
        [self.minBtn addGestureRecognizer:minPan];
        UIImageView *lowerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SliderHeight / 4, SliderHeight / 4, SliderHeight / 2, SliderHeight / 2)];
        self.minImage = lowerImage;
        [self.minBtn addSubview:self.minImage];
        [self.sliderView addSubview:self.minBtn];
        
        UIButton *maxView =[[UIButton alloc] init];
        if (dMax <= sMax) {
            maxView.frame = CGRectMake(dMax / (sMax - sMin) * self.realSection,0, SliderHeight, SliderHeight);
        }else{
            maxView.frame = CGRectMake(frame.size.width - self.btnRadius * 3,0, SliderHeight, SliderHeight);
        }
        self.maxBtn = maxView;
        self.maxBtn.backgroundColor = [UIColor orangeColor];
        self.maxBtn.layer.cornerRadius = self.btnRadius;
        self.maxBtn.clipsToBounds = YES;
        UIPanGestureRecognizer *maxPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(maxPanChange:)];
        [self.maxBtn addGestureRecognizer:maxPan];
        UIImageView *upperImage = [[UIImageView alloc] initWithFrame:CGRectMake(SliderHeight / 4, SliderHeight / 4, SliderHeight / 2, SliderHeight / 2)];
        self.maxImage = upperImage;
        [self.maxBtn addSubview:self.maxImage];
        [self.sliderView addSubview:self.maxBtn];
        
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapChange:)];
        [self.sliderView addGestureRecognizer:viewTap];
        
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        self.minLab = minLabel;
        self.minLab.backgroundColor = [UIColor clearColor];
        self.minLab.textAlignment = NSTextAlignmentCenter;
        self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        self.minLab.font = [UIFont systemFontOfSize:18];
        self.minLab.textColor = HEXCOLOR(0x1489c8);
        self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
        [self addSubview:self.minLab];
        
        UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        self.maxLab = maxLabel;
        self.maxLab.backgroundColor = [UIColor clearColor];
        self.maxLab.textAlignment = NSTextAlignmentCenter;
        if (dMax <= sMax) {
            self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
        }else{
            self.maxLab.text = [NSString stringWithFormat:Wuxian];

        }
        self.maxLab.font = [UIFont systemFontOfSize:18];
        self.maxLab.textColor = HEXCOLOR(0x1489c8);
        self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
        [self addSubview:self.maxLab];
    }
    return self;
}

-(void)setMinButtonImage:(UIImage *)image{
    self.minBtn.backgroundColor = [UIColor clearColor];
    self.minImage.image = image;
}
-(void)setMaxButtonImage:(UIImage *)image{
    self.maxBtn.backgroundColor = [UIColor clearColor];
    self.maxImage.image = image;
}

-(void)setPressLineColor:(UIColor *)color{
    self.lineView.backgroundColor = color;
}
-(void)setMidLineColor:(UIColor *)color{
    self.midView.backgroundColor = color;
}

-(void)minPanChange:(UIPanGestureRecognizer *)sender{
    [self.sliderView bringSubviewToFront:self.minBtn];
    CGPoint tapPoint = [sender locationInView:self];
    if (tapPoint.x <= self.maxBtn.center.x && tapPoint.x >= self.btnRadius * 2 && tapPoint.x <= self.frame.size.width - self.btnRadius * 4) {
        if (tapPoint.x <= self.maxBtn.center.x && tapPoint.x <= self.frame.size.width - self.btnRadius * 5) {
            self.minBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
            self.curMin = (int)(((self.minBtn.center.x - self.btnRadius * 2) / self.realSection)* (self.sliderMax - self.sliderMin) / 10) * 10  + self.sliderMin;
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        }
        if (tapPoint.x >= self.frame.size.width -self.btnRadius * 5 && tapPoint.x <= self.frame.size.width - self.btnRadius * 4.5) {
            self.minBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
            self.curMin = self.sliderMax;
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        }
        if (tapPoint.x >= self.frame.size.width - self.btnRadius * 4.5) {
            [UIView animateWithDuration:Duration animations:^{
                self.minBtn.center = CGPointMake(self.frame.size.width - self.btnRadius * 5, self.sHeight / 2);
                self.curMin = self.sliderMax;
                self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
                self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
            }];
        }
    }
    if (tapPoint.x < self.btnRadius * 2 && tapPoint.x >= self.btnRadius) {
        if (tapPoint.x < self.btnRadius * 2 && tapPoint.x > self.btnRadius * 1.9) {
            self.minBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.curMin = self.sliderMin;
            self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
          self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        }
        if (tapPoint.x <= self.btnRadius * 1.9 && tapPoint.x >= self.btnRadius) {
            [UIView animateWithDuration:Duration animations:^{
                self.minBtn.center = CGPointMake(self.btnRadius * 2, self.sHeight / 2);
                self.curMin = self.sliderMin;
                self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
                self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
            }];
        }
    }
    
    [self.delegate sliderChangeValueMin:self.curMin andMax:self.curMax andMinCenter:self.minBtn.center andMaxCenter:self.maxBtn.center];
}
-(void)maxPanChange:(UIPanGestureRecognizer *)sender{
    [self.sliderView bringSubviewToFront:self.maxBtn];
    CGPoint tapPoint = [sender locationInView:self];
    if (tapPoint.x >= self.minBtn.center.x && tapPoint.x <= self.frame.size.width - self.btnRadius) {
        if (tapPoint.x >= self.minBtn.center.x && tapPoint.x <= self.frame.size.width - self.btnRadius * 5) {
            self.maxBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
            self.curMax = (int)(((self.maxBtn.center.x - self.btnRadius * 2) / self.realSection)* (self.sliderMax - self.sliderMin) / 10) * 10  + self.sliderMin;
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
        }
        if (tapPoint.x >= self.frame.size.width - self.btnRadius * 5 && tapPoint.x <= self.frame.size.width - self.btnRadius * 4.5) {
            self.maxBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
            self.curMax = self.sliderMax;
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
        }
        if (tapPoint.x > self.frame.size.width - self.btnRadius * 4.5 && tapPoint.x <= self.frame.size.width - self.btnRadius) {
            if ([sender translationInView:self].x > 0) {
                [UIView animateWithDuration:Duration animations:^{
                     self.curMax = self.unlimited;
                     self.maxBtn.center = CGPointMake(self.frame.size.width - self.btnRadius, self.sHeight / 2);
                     self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
                     self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                     self.maxLab.text = [NSString stringWithFormat:Wuxian];
                 }];
            }
            if ([sender translationInView:self].x < 0) {
                [UIView animateWithDuration:Duration animations:^{
                    self.curMax = self.sliderMax;
                    self.maxBtn.center = CGPointMake(self.frame.size.width - self.btnRadius * 5, self.sHeight / 2);
                    self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
                    self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                    self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
                }];
            }
        }
    }
    [self.delegate sliderChangeValueMin:self.curMin andMax:self.curMax andMinCenter:self.minBtn.center andMaxCenter:self.maxBtn.center];
}
-(void)viewTapChange:(UITapGestureRecognizer *)sender{
    CGPoint tapPoint = [sender locationInView:self];
    if (tapPoint.x < self.btnRadius * 2 && tapPoint.x >= self.btnRadius) {
        [UIView animateWithDuration:Duration animations:^{
             self.curMin = self.sliderMin;
            self.minBtn.center = CGPointMake(self.btnRadius * 2, self.sHeight / 2);
            self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
            self.midView.frame = CGRectMake(self.btnRadius * 2, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        }];
    }
    if ((tapPoint.x < self.minBtn.center.x && tapPoint.x >= self.btnRadius * 2) || (self.maxBtn.center.x - tapPoint.x  > tapPoint.x - self.minBtn.center.x && tapPoint.x >= self.btnRadius * 2 && tapPoint.x <= self.frame.size.width - self.btnRadius * 5)) {
        [UIView animateWithDuration:Duration animations:^{
            self.minBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.minLab.center = CGPointMake(self.minBtn.center.x, SLSection);
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.curMin = (int)(((self.minBtn.center.x - self.btnRadius * 2) / self.realSection)* (self.sliderMax - self.sliderMin) / 10) * 10  + self.sliderMin;
            self.minLab.text = [NSString stringWithFormat:@"%d",(int)self.curMin];
        }];
    }
    if ((tapPoint.x > self.maxBtn.center.x && tapPoint.x <= self.frame.size.width - self.btnRadius * 5) || ( self.maxBtn.center.x - tapPoint.x  < tapPoint.x - self.minBtn.center.x && tapPoint.x <= self.frame.size.width - self.btnRadius * 5 && self.minBtn.center.x < self.frame.size.width - self.btnRadius * 5)) {
        [UIView animateWithDuration:Duration animations:^{
            self.maxBtn.center = CGPointMake(tapPoint.x, self.sHeight / 2);
            self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
            self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
            self.curMax = (int)(((self.maxBtn.center.x - self.btnRadius * 2) / self.realSection)* (self.sliderMax - self.sliderMin) / 10) * 10  + self.sliderMin;
            self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
        }];
    }
    if (tapPoint.x > self.frame.size.width - self.btnRadius * 5 && tapPoint.x <= self.frame.size.width - self.btnRadius) {
        if (tapPoint.x > self.frame.size.width - self.btnRadius * 5 && tapPoint.x < self.frame.size.width - self.btnRadius * 3) {
            [UIView animateWithDuration:Duration animations:^{
                self.curMax = self.sliderMax;
                self.maxBtn.center = CGPointMake(self.frame.size.width - self.btnRadius * 5, self.sHeight / 2);
                self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
                self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                self.maxLab.text = [NSString stringWithFormat:@"%d",(int)self.curMax];
            }];
        }
        if (tapPoint.x > self.frame.size.width - self.btnRadius * 3 && tapPoint.x <= self.frame.size.width - self.btnRadius) {
            [UIView animateWithDuration:Duration
                             animations:^{
                self.curMax = self.unlimited;
                self.maxBtn.center = CGPointMake(self.frame.size.width - self.btnRadius, self.sHeight / 2);
                self.maxLab.center = CGPointMake(self.maxBtn.center.x, SLSection);
                self.midView.frame = CGRectMake(self.minBtn.center.x, self.sHeight / 2 - 1, self.maxBtn.center.x - self.minBtn.center.x, 2);
                self.maxLab.text = [NSString stringWithFormat:Wuxian];
            }];
        }
    }
    [self.delegate sliderChangeValueMin:self.curMin andMax:self.curMax andMinCenter:self.minBtn.center andMaxCenter:self.maxBtn.center];
}

@end
