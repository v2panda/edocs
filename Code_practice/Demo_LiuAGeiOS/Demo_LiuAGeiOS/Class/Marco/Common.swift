//
//  Common.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/4.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import MJRefresh
/**
 手机型号枚举
 */
enum iPhoneModel {
    
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6p
    case iPad
    
    /**
     获取当前手机型号
     
     - returns: 返回手机型号枚举
     */
    static func getCurrentModel() -> iPhoneModel {
        switch SCREEN_HEIGHT {
        case 480:
            return .iPhone4
        case 568:
            return .iPhone5
        case 667:
            return .iPhone6
        case 736:
            return .iPhone6p
        default:
            return .iPad
        }
    }
}

/**
 UserDefaults 设置
 */
let USER_DEFAULTS = NSUserDefaults.standardUserDefaults()


let SELECTED_ARRAY = "selectedArrayUserDefaults"
let OPTIONAL_ARRAY = "optionalArrayUserDefaults"

/**
 快速创建上拉加载更多控件
 */
func setupFooterRefresh(target: AnyObject, action: Selector) -> MJRefreshAutoNormalFooter {
    let footerRefresh = MJRefreshAutoNormalFooter(refreshingTarget: target, refreshingAction: action)
    footerRefresh.automaticallyHidden = true
    footerRefresh.setTitle("正在为您加载更多...", forState: MJRefreshState.Refreshing)
    footerRefresh.setTitle("上拉即可加载更多...", forState: MJRefreshState.Idle)
    footerRefresh.setTitle("没有更多数据啦...", forState: MJRefreshState.NoMoreData)
    return footerRefresh
}

/**
 快速创建下拉加载最新控件
 */
func setupHeaderRefresh(target: AnyObject, action: Selector) -> MJRefreshNormalHeader {
    let headerRefresh = MJRefreshNormalHeader(refreshingTarget: target, refreshingAction: action)
    headerRefresh.lastUpdatedTimeLabel.hidden = true
    headerRefresh.stateLabel.hidden = true
    return headerRefresh
}


/// 保存夜间模式的状态的key
let NIGHT_KEY = "night"

/// 保存正文字体类型的key
let CONTENT_FONT_TYPE_KEY = "contentFontType"

/// 保存正文字体大小的key
let CONTENT_FONT_SIZE_KEY = "contentFontSize"

/// 导航栏背景颜色
let NAVIGATIONBAR_COLOR = UIColor(red:1,  green:1,  blue:1, alpha:1)

/// 橙色
let NAVIGATIONBAR_COLOR_DARK = UIColor.colorWithRGB(231, g: 129, b: 112)

/// 按钮不能点的时候的颜色
let DISENABLED_BUTTON_COLOR = UIColor.colorWithRGB(178, g: 178, b: 178)

/// 控制器背景颜色
let BACKGROUND_COLOR = UIColor.colorWithRGB(252, g: 252, b: 252)

/// 侧栏背景色
let LEFT_BACKGROUND_COLOR = UIColor(red:0.133,  green:0.133,  blue:0.133, alpha:1)

/// 设置界面分割线颜色
let SETTING_SEPARATOR_COLOR = UIColor(white: 0.5, alpha: 0.3)

/// 全局边距
let MARGIN: CGFloat = 12

/// 全局圆角
let CORNER_RADIUS: CGFloat = 5

/// 屏幕宽度
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width

/// 屏幕高度
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

/// 屏幕bounds
let SCREEN_BOUNDS = UIScreen.mainScreen().bounds

/// 全局遮罩透明度
let GLOBAL_SHADOW_ALPHA: CGFloat = 0.5
