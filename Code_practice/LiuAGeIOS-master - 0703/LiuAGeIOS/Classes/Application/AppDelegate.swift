//
//  AppDelegate.swift
//  BaoKanIOS
//
//  Created by jianfeng on 15/12/20.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // 给注册推送时用 - 因为注册推送想在主界面加载出来才询问是否授权
    var launchOptions: [NSObject: AnyObject]?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupRootViewController() // 配置控制器
        setupGlobalStyle()        // 配置全局样式
        setupGlobalData()         // 配置全局数据
        setupKeyBoardManager()    // 配置键盘管理
        setupShareSDK()           // 配置shareSDK
        self.launchOptions = launchOptions
        return true
    }
    
    /**
     配置全局数据
     */
    private func setupGlobalData() {
        // 设置初始正文字体大小
        if NSUserDefaults.standardUserDefaults().integerForKey(CONTENT_FONT_SIZE_KEY) == 0 || NSUserDefaults.standardUserDefaults().stringForKey(CONTENT_FONT_TYPE_KEY) == nil {
            // 字体  16小   18中   20大   22超大  24巨大   26极大  共6个等级，可以用枚举列举使用
            NSUserDefaults.standardUserDefaults().setInteger(18, forKey: CONTENT_FONT_SIZE_KEY)
            NSUserDefaults.standardUserDefaults().setObject("", forKey: CONTENT_FONT_TYPE_KEY)
        }
        
        // 验证缓存的账号是否有效
        JFAccountModel.checkUserInfo({})
        
        // 是否需要更新本地搜索关键词列表
        JFNetworkTool.shareNetworkTool.shouldUpdateKeyboardList({ (update) in
            if update {
                JFNewsDALManager.shareManager.updateSearchKeyListData()
            }
        })
    }
    
    /**
     配置shareSDK
     */
    private func setupShareSDK() {
        
        ShareSDK.registerApp(SHARESDK_APP_KEY,
                             activePlatforms: [
                                SSDKPlatformType.TypeSinaWeibo.rawValue,
                                SSDKPlatformType.TypeQQ.rawValue,
                                SSDKPlatformType.TypeWechat.rawValue],
                             onImport: {(platform : SSDKPlatformType) -> Void in
                                switch platform {
                                case SSDKPlatformType.TypeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case SSDKPlatformType.TypeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }},
                             onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                                switch platform {
                                case SSDKPlatformType.TypeSinaWeibo:
                                    appInfo.SSDKSetupSinaWeiboByAppKey(WB_APP_KEY, appSecret : WB_APP_SECRET, redirectUri : WB_REDIRECT_URL, authType : SSDKAuthTypeBoth)
                                case SSDKPlatformType.TypeWechat:
                                    appInfo.SSDKSetupWeChatByAppId(WX_APP_ID, appSecret: WX_APP_SECRET)
                                case SSDKPlatformType.TypeQQ:
                                    appInfo.SSDKSetupQQByAppId(QQ_APP_ID, appKey: QQ_APP_KEY, authType: SSDKAuthTypeBoth)
                                default:
                                    break
                                }})
    }
    
    /**
     配置键盘管理者
     */
    private func setupKeyBoardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    /**
     全局样式
     */
    private func setupGlobalStyle() {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        JFProgressHUD.setupHUD() // 配置HUD
    }
    
    /**
     添加根控制器
     */
    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let newsVc = UIStoryboard.init(name: "JFNewsViewController", bundle: nil).instantiateInitialViewController()
        
        // 这段代码是为了清除本地用户缓存，因为修改了字段，不清除会崩
        if isNewVersion() {
//            window?.rootViewController =  JFNewFeatureViewController()
            window?.rootViewController = newsVc
        } else {
            window?.rootViewController = newsVc
        }
        
        window?.makeKeyAndVisible()
        
        // 添加帧数到窗口左下角
//        window?.addSubview(JFFPSLabel(frame: CGRect(x: SCREEN_WIDTH - 60, y: 26, width: 50, height: 30)))
        
        // 启动图动画
        let launchVc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
        launchVc.view.frame = SCREEN_BOUNDS
        window?.addSubview(launchVc.view)
        
        UIView.animateWithDuration(0.6, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { 
            launchVc.view.alpha = 0
            launchVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
            }) { (_) in
                launchVc.view.removeFromSuperview()
        }
    }
    
    /**
     判断是否是新版本
     */
    private func isNewVersion() -> Bool {
        // 获取当前的版本号
        let versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionString)!
        
        // 获取到之前的版本号
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandboxVersionKey)
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: sandboxVersionKey)
        
        return currentVersion > sandboxVersion
    }
    
    /**
     配置极光推送
     */
    func setupJPush() {
        JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Alert.rawValue | UIUserNotificationType.Sound.rawValue, categories: nil)
        JPUSHService.setupWithOption(launchOptions, appKey: JPUSH_APP_KEY, channel: JPUSH_CHANNEL, apsForProduction: JPUSH_IS_PRODUCTION)
        JPUSHService.crashLogON()
        JPUSHService.setLogOFF()
        
        // 延迟发送通知（app被杀死进程后收到通知，然后通过点击通知打开app在这个方法中发送通知）
        performSelector(#selector(sendNotification(_:)), withObject: launchOptions, afterDelay: 1)
    }
    
    /**
     发送通知
     */
    @objc private func sendNotification(launchOptions: [NSObject: AnyObject]?) {
        if let options = launchOptions {
            let userInfo = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject]
            NSNotificationCenter.defaultCenter().postNotificationName("didReceiveRemoteNotificationOfJPush", object: nil, userInfo: userInfo)
        }
    }
    
    /**
     传递deviceToken注册远程通知
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    /**
     注册远程通知失败
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    /**
     iOS7后接收到远程通知
     */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NewData)
        
        if application.applicationState == .Background || application.applicationState == .Inactive {
            application.applicationIconBadgeNumber = 0
            NSNotificationCenter.defaultCenter().postNotificationName("didReceiveRemoteNotificationOfJPush", object: nil, userInfo: userInfo)
        } else if application.applicationState == .Active {
            application.applicationIconBadgeNumber = 0
            
            let message = userInfo["aps"]!["alert"] as! String
            let alertC = UIAlertController(title: "收到新的消息", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let confrimAction = UIAlertAction(title: "查看", style: UIAlertActionStyle.Destructive, handler: { (action) in
                NSNotificationCenter.defaultCenter().postNotificationName("didReceiveRemoteNotificationOfJPush", object: nil, userInfo: userInfo)
            })
            let cancelAction = UIAlertAction(title: "忽略", style: UIAlertActionStyle.Default, handler: { (action) in
                
            })
            alertC.addAction(confrimAction)
            alertC.addAction(cancelAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertC, animated: true, completion: nil)
        }
    }
    
    /**
     接收到本地通知
     */
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        JPUSHService.showLocalNotificationAtFront(notification, identifierKey: nil)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        JFNewsDALManager.shareManager.clearCacheData()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
}

