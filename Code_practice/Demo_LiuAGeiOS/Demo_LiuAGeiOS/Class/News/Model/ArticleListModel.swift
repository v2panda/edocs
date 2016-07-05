//
//  ArticleListModel.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit

class ArticleListModel: NSObject {
    /// 文章分类id
    var classid: String?
    
    /// 文章id
    var id: String?
    
    /// 文章标题
    var title: String?
    
    /// 文章来源
    var befrom: String?
    
    /// 点击量
    var onclick: String?
    
    /// 创建文章时间戳
    var newstime: String?
    
    /// 标题图片url
    var titlepic: String?
    
    /// 多图数组
    var morepic: [String]?
    
    /// 简介
    var smalltext: String?
    
    /// 缓存行高
    var rowHeight: CGFloat = 0.0
    
    /// 时间戳转换成时间
    var newstimeString: String {
        return newstime!.timeStampTpString()
    }
    
    /**
     字典转模型构造方法
     */
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 重写此方法 防止赋值失败导致崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /**
     清除缓存
     
     - parameter classid: 要清除的分类id
     */
    class func cleanCache(classid: Int) {
        NewsDALManager.shareManager.cleanCache(classid)
    }
    
    
    
}
