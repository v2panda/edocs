//
//  JFNavigationController.swift
//  BaoKanIOS
//
//  Created by jianfeng on 15/12/20.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationBar
        navBar.barTintColor = NAVIGATIONBAR_COLOR
        navBar.translucent = false
        navBar.barStyle = UIBarStyle.Black
        navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = UIImage()
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.colorWithRGB(47, g: 47, b: 47),
            NSFontAttributeName : UIFont.systemFontOfSize(16)
        ]
        
        // 全屏返回手势
        panGestureBack()
    }
    
    /**
     全屏返回手势
     */
    func panGestureBack() {
        let target = interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        interactivePopGestureRecognizer?.enabled = false
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gesture: UIGestureRecognizer) -> Bool {
        if childViewControllers.count == 1 {
            return false
        } else {
            return true
        }
    }
    
    /**
     拦截push操作
     
     - parameter viewController: 即将压入栈的控制器
     - parameter animated:       是否动画
     */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        
        super.pushViewController(viewController, animated: animated)
        
        // 压入栈后创建返回按钮
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "top_navigation_back")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal),
            style: UIBarButtonItemStyle.Done,
            target: self,
            action: #selector(back)
        )
    }
    
    /**
     全局返回操作
     */
    @objc private func back() {
        popViewControllerAnimated(true)
    }
    
}
