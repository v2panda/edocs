//
//  UINavigationController+PDAPopGesture.h
//  PopGestureDemo-1010
//
//  Created by Panda on 15/10/12.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PDAPopGesture)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *pda_popGestureRecognizer;

@end

@interface UIViewController (PDAPopGesture)

@property (nonatomic, assign) BOOL pda_interactivePopDisabled;

@property (nonatomic, assign) CGFloat pda_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
