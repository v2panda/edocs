//
//  JFArticleDetailModel.swift
//  BaoKanIOS
//
//  Created by jianfeng on 16/2/19.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

/// 资讯正文模型 - 图库通用
class JFArticleDetailModel: NSObject {
    
    /// 顶贴数
    var top: String?
    
    /// 踩帖数
    var down: String?
    
    /// 文章标题
    var title: String?
    
    /// 发布时间戳
    var newstime: String?
    
    /// 文章内容
    var newstext: String?
    
    /// 文章url
    var titleurl: String?
    
    /// 文章id
    var id: String?
    
    /// 当前子分类id
    var classid: String?
    
    /// 评论数量
    var plnum: String?
    
    /// 是否收藏 1收藏  0未收藏
    var havefava: String?
    
    /// 文章简介
    var smalltext: String?
    
    /// 标题图片
    var titlepic: String?
    
    /// 所有图片
    var allphoto: [AnyObject]?
    
    /// 信息来源 - 如果没有则返回空字符串，所以可以直接强拆
    var befrom: String?
    
    /// 是否赞过
    var isStar = false
    
    var morepics: [JFPhotoDetailModel]?
    
    var otherLinks: [JFOtherLinkModel]?
    
    /**
     字典转模型构造方法
     */
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    /**
     KVC赋值每个属性的时候都会来，在这里手动转子模型
     
     - parameter value: 值
     - parameter key:   键
     */
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "morepic" {
            if let array = value as? [[String: AnyObject]] {
                var morepicModels = [JFPhotoDetailModel]()
                for dict in array {
                    let morepicModel = JFPhotoDetailModel(dict: dict)
                    morepicModels.append(morepicModel)
                }
                morepics = morepicModels
            }
            return
        } else if key == "otherLink" {
            if let array = value as? [[String: AnyObject]] {
                var otherModels = [JFOtherLinkModel]()
                for dict in array {
                    let otherModel = JFOtherLinkModel(dict: dict)
                    otherModels.append(otherModel)
                }
                otherLinks = otherModels
            }
            return
        }
        return super.setValue(value, forKey: key)
    }
    
    /**
     加载资讯数据
     
     - parameter classid:   资讯分类id
     - parameter pageIndex: 加载分页
     - parameter type:      1为资讯列表 2为资讯幻灯片
     - parameter cache:     是否需要使用缓存
     - parameter finished:  数据回调
     */
    class func loadNewsDetail(classid: Int, id: Int, cache: Bool, finished: (articleDetailModel: JFArticleDetailModel?, error: NSError?) -> ()) {
        
        NewsDALManager.shareManager.loadNewsDetail(classid, id: id, cache: cache) { (result, error) in
            
            // 请求失败
            if error != nil || result == nil {
                finished(articleDetailModel: nil, error: error)
                return
            }
            
            // 正文数据
            let dict = result!.dictionaryObject
            finished(articleDetailModel: JFArticleDetailModel(dict: dict!), error: nil)
        }
    }
    
}

/// 相关链接模型
class JFOtherLinkModel: NSObject {
    
    var classid: String?
    
    var id: String?
    
    var titlepic: String?
    
    var onclick: String?
    
    var title: String?
    
    var classname: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}

/// 图库详情模型
class JFPhotoDetailModel: NSObject {
    
    /// 图片标题
    var title: String?
    
    /// 图片描述
    var caption: String?
    
    /// 图片url
    var bigpic: String?
    
    /**
     字典转模型构造方法
     */
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
}
