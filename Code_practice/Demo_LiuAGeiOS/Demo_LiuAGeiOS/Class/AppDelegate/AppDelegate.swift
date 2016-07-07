//
//  AppDelegate.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupRootViewController() // 配置控制器
        
        // 设置初始正文字体大小
        if NSUserDefaults.standardUserDefaults().integerForKey(CONTENT_FONT_SIZE_KEY) == 0 || NSUserDefaults.standardUserDefaults().stringForKey(CONTENT_FONT_TYPE_KEY) == nil {
            // 字体  16小   18中   20大   22超大  24巨大   26极大  共6个等级，可以用枚举列举使用
            NSUserDefaults.standardUserDefaults().setInteger(18, forKey: CONTENT_FONT_SIZE_KEY)
            NSUserDefaults.standardUserDefaults().setObject("", forKey: CONTENT_FONT_TYPE_KEY)
        }
        
        return true
    }

    /**
     *  配置控制器
     */
    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let newVC  = UIStoryboard.init(name: "NewsViewControllerSB", bundle: nil).instantiateInitialViewController()
        
        window?.rootViewController = newVC
        
        window?.makeKeyAndVisible()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        NewsDALManager.shareManager.clearCacheData()
    }
    
}

