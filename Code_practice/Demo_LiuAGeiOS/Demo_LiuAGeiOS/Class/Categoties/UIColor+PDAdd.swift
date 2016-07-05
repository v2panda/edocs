//
//  UIColor+PDAdd.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/4.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     *  RGB颜色
     */
    class func colorWithRGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}