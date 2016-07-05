//
//  NetWorkTool.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import SwiftyJSON

// 网络请求回调闭包 success:是否成功   result:字典数据 error:错误信息
typealias NetworkFinished = (success: Bool, result: JSON?, error: NSError?) -> ()

class NetWorkTool: NSObject {
    static let shareNetworkTool = NetWorkTool()
}

//MARK: - 基础请求方法
extension NetWorkTool {
    
    func get(APIString: String, parameters: [String : AnyObject]?, finished: NetworkFinished)  {
        
        var urlString = ""
        if APIString.hasPrefix("http") {
            urlString = APIString
        }else {
            urlString = "\(API_URL)\(APIString)"
        }
        
    }
    
    
}
