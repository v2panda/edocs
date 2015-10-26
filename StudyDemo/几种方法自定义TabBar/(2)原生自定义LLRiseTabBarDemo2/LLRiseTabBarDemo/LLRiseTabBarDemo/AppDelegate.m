//
//  AppDelegate.m
//  LLRiseTabBarDemo
//
//  Created by HelloWorld on 10/18/15.
//  Copyright © 2015 melody. All rights reserved.
//

#import "AppDelegate.h"


#import "LLHomeViewController.h"
#import "LLSameCityViewController.h"
#import "LLMessageViewController.h"
#import "LLMineViewController.h"
#import "LYSpaceVC.h"
#import "UIImage+LYColor.h"
@interface AppDelegate () <UIActionSheetDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
	LLHomeViewController *homeViewController = [[LLHomeViewController alloc] init];
	LLSameCityViewController *sameCityViewController = [[LLSameCityViewController alloc] init];
	LLMessageViewController *messageViewController = [[LLMessageViewController alloc] init];
	LLMineViewController *mineViewController = [[LLMineViewController alloc] init];
    LYSpaceVC *spaceVC = [[LYSpaceVC alloc] init];
    [homeViewController.tabBarItem setTitle:@"首页"];
    [homeViewController.tabBarItem setImage:[UIImage imageNamed:@"home_normal"]];
    [homeViewController.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_highlight"]];
    
    [sameCityViewController.tabBarItem setTitle:@"同城"];
    [sameCityViewController.tabBarItem setImage:[UIImage imageNamed:@"mycity_normal"]];
    [sameCityViewController.tabBarItem setSelectedImage:[UIImage imageNamed:@"mycity_highlight"]];
    
    [messageViewController.tabBarItem setTitle:@"消息"];
    
    [messageViewController.tabBarItem setImage:[UIImage imageNamed:@"home_normal"]];
    [messageViewController.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_highlight"]];
    
    [mineViewController.tabBarItem setTitle:@"我的"];
    [mineViewController.tabBarItem setImage:[UIImage imageNamed:@"home_normal"]];
    [mineViewController.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_highlight"]];
    
    [spaceVC.tabBarItem setTitle:@"发布"];
	
	UITabBarController *tabbarController = [[UITabBarController alloc] init];
	tabbarController.viewControllers = @[homeViewController, sameCityViewController, spaceVC, messageViewController, mineViewController];
    
    //去掉上部的黑色线条，
    //如果加上黑色线条的话可以这样。view自定义高度为1，宽度为tabBar的宽度 [tabbarController.tabBar addSubview:view];
//	[[UITabBar appearance] setBackgroundImage:[UIImage imageWithLYColor:[UIColor groupTableViewBackgroundColor]]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithLYColor:[UIColor whiteColor]]];
	[[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, SCREEN_WIDTH, 5)];
    topLine.image = [UIImage imageNamed:@"tapbar_top_line"];
    [tabbarController.tabBar addSubview:topLine];
    
    //设置中间的tabBarItem 这个可以随便自定义
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((tabbarController.tabBar.bounds.size.width-120)/2, tabbarController.tabBar.bounds.size.height - 85, 120, 80)];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
    [tabbarController.tabBar addSubview:button];
    [tabbarController.tabBar bringSubviewToFront:button];
    
    [button addTarget:self action:@selector(tabBarDidSelectedRiseButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    for (UITabBarItem *tbi in tabbarController.tabBar.items) {
        tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tbi.selectedImage = [tbi.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
	
	
	self.window.rootViewController = tabbarController;
	
	return YES;
}

#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {
	UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
	UIViewController *viewController = tabBarController.selectedViewController;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"取消"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"拍照", @"从相册选取", @"淘宝一键转卖", nil];
	[actionSheet showInView:viewController.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"buttonIndex = %ld", buttonIndex);
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
