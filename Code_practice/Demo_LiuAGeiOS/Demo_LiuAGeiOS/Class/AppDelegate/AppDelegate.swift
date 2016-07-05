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

