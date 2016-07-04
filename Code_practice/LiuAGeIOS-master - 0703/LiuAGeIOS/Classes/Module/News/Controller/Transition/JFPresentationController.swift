//
//  JFPresentationController.swift
//  popoverDemo
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPresentationController: UIPresentationController {
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView()?.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
        
        // 关闭按钮
        let closeButton = UIButton(frame: CGRect(x: SCREEN_WIDTH - 40, y: 64, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "channel_nav_plus"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: #selector(didTappedCloseButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        containerView?.addSubview(closeButton)
        
        UIView.animateWithDuration(0.5, animations: {
            closeButton.imageView!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) - 0.01)
        })
        
    }
    
    /**
     容器视图区域的点击手势
     */
    @objc private func didTappedCloseButton(button: UIButton) {
        // 发出栏目管理视图即将消失的通知
        NSNotificationCenter.defaultCenter().postNotificationName("columnViewWillDismiss", object: nil)
        UIView.animateWithDuration(0.5, animations: { 
            button.imageView!.transform = CGAffineTransformIdentity
            }) { (_) in
                button.removeFromSuperview()
        }
        
        // 会触发自定义dismiss动画
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}