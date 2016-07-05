//
//  String+PDAdd.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import Foundation

extension String {
    /**
     时间戳转为时间
     
     - returns: 时间字符串
     */
    func timeStampTpString() -> String {
        
        let sting = NSString(string: self)
        let timeSta:NSTimeInterval = sting.doubleValue
        let date = NSDate(timeIntervalSince1970: timeSta)
        return date.dateDescription()
    }
}