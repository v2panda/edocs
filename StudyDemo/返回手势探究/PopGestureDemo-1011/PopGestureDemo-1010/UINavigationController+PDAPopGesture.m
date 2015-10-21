//
//  UINavigationController+PDAPopGesture.m
//  PopGestureDemo-1010
//
//  Created by Panda on 15/10/12.
//  Copyright © 2015年 Panda. All rights reserved.
//

#import "UINavigationController+PDAPopGesture.h"
#import <objc/runtime.h>

@interface PDAFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation PDAFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // 当为根控制器时，手势不执行。
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // 设置一个页面是否显示此手势，默认为NO 显示。
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.pda_interactivePopDisabled) {
        return NO;
    }
    
    //  手势滑动距左边框的距离超过maxAllowedInitialDistance 手势不执行。
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.pda_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // 当push、pop动画正在执行时，手势不执行。
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    //  向左边(反方向)拖动，手势不执行。
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end
@implementation UINavigationController (PDAPopGesture)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(pda_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)pda_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.pda_popGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        //  添加我们自己的侧滑返回手势
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.pda_popGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        /*
         新建一个UIPanGestureRecognizer，让它的触发和系统的这个手势相同，
         这就需要利用runtime获取系统手势的target和action。
         */
        //  用KVC取出target和action
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        //  将自定义的代理（手势执行条件）传给手势的delegate
        self.pda_popGestureRecognizer.delegate = self.pda_popGestureRecognizerDelegate;
        //  将target和action传给手势
        [self.pda_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        //  设置系统的为NO
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Forward to primary implementation.
    //  执行原本的方法
    if (![self.viewControllers containsObject:viewController]) {
        [self pda_pushViewController:viewController animated:animated];
    }
}

//  隐式声明 只写了get方法
- (PDAFullscreenPopGestureRecognizerDelegate *)pda_popGestureRecognizerDelegate
{
    PDAFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[PDAFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        //  设置self(UINavigationController)和delegate关联
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)pda_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}
@end

@implementation UIViewController (PDAPopGesture)



@end