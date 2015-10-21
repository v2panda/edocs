//
//  UINavigationController+PDAFullScreenPopGesture.h
//  PopGestureDemo-1010
//
//  Created by Panda on 15/10/10.
//  Copyright © 2015年 Panda. All rights reserved.
//
//  自定义全局侧滑返回手势

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UINavigationController (PDAFullScreenPopGesture)

// 自定义侧滑返回的手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *pda_fullscreenPopGestureRecognizer;

@end


@interface UIViewController (PDAFullscreenPopGesture)

/// 是否需要显示此手势 默认为NO 显示
@property (nonatomic, assign) BOOL pda_interactivePopDisabled;


/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.
@property (nonatomic, assign) CGFloat pda_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end