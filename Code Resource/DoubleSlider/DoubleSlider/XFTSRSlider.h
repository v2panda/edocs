//
//  XFTSRSlider.h
//  Test
//
//  Created by WangPan on 15/4/2.
//  Copyright (c) 2015年 WangPan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XFTSRSliderDelegate <NSObject>
-(void)sliderChangeValueMin :(CGFloat)min andMax:(CGFloat)max andMinCenter:(CGPoint)minCenter andMaxCenter :(CGPoint)maxCenter;
@end
@interface XFTSRSlider : UIView

-(id)initWithFrame:(CGRect)frame andSliderHeight:(CGFloat)SliderHeight andDefaultMin:(CGFloat)dMin andDefaultMax:(CGFloat)dMax andSliderMin:(CGFloat)sMin andSliderMax:(CGFloat)sMax andUnlimated:(CGFloat)unlimated;

-(void)setMinButtonImage:(UIImage *)image;
-(void)setMaxButtonImage:(UIImage *)image;

-(void)setPressLineColor:(UIColor *)color;
-(void)setMidLineColor:(UIColor *)color;

@property (nonatomic ,weak) id <XFTSRSliderDelegate> delegate;
@end
