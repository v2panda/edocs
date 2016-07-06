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
    
    /**
     加载资讯列表数据
     
     - parameter classid:   资讯分类id
     - parameter pageIndex: 加载分页
     - parameter type:      1为资讯列表 2为资讯幻灯片
     - parameter cache:     是否需要使用缓存
     - parameter finished:  数据回调
     */
    class func loadNewsList(classid: Int, pageIndex: Int, type: Int, cache: Bool, finished: (articleListModels: [ArticleListModel]?, error: NSError?) -> ()) {
        
        // 模型找数据访问层请求数据 - 然后处理数据回调给调用者直接使用
        NewsDALManager.shareManager.loadNewsList(classid, pageIndex: pageIndex, type: type, cache: cache) { (result, error) in
            
            // 请求失败
            if error != nil || result == nil {
                finished(articleListModels: nil, error: error)
                return
            }
            
            // 没有数据了
            if result?.count == 0 {
                finished(articleListModels: [ArticleListModel](), error: nil)
                return
            }
            
            let data = result!.arrayValue
            var articleListModels = [ArticleListModel]()
            
            // 遍历转模型添加数据
            for article in data {
                let postModel = ArticleListModel(dict: article.dictionaryObject!)
                articleListModels.append(postModel)
            }
            
            finished(articleListModels: articleListModels, error: nil)
        }
        
    }
    
    
}
