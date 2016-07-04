//
//  JFArticleListModel.swift
//  BaoKanIOS
//
//  Created by jianfeng on 16/1/14.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFArticleListModel: NSObject {
    
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
        return newstime!.timeStampToString()
    }
    
    /**
     字典转模型构造方法
     */
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /**
     清除缓存
     
     - parameter classid: 要清除的分类id
     */
    class func cleanCache(classid: Int) {
        JFNewsDALManager.shareManager.cleanCache(classid)
    }
    
    /**
     加载资讯列表数据
     
     - parameter classid:   资讯分类id
     - parameter pageIndex: 加载分页
     - parameter type:      1为资讯列表 2为资讯幻灯片
     - parameter cache:     是否需要使用缓存
     - parameter finished:  数据回调
     */
    class func loadNewsList(classid: Int, pageIndex: Int, type: Int, cache: Bool, finished: (articleListModels: [JFArticleListModel]?, error: NSError?) -> ()) {
        
        // 模型找数据访问层请求数据 - 然后处理数据回调给调用者直接使用
        JFNewsDALManager.shareManager.loadNewsList(classid, pageIndex: pageIndex, type: type, cache: cache) { (result, error) in
            
            // 请求失败
            if error != nil || result == nil {
                finished(articleListModels: nil, error: error)
                return
            }
            
            // 没有数据了
            if result?.count == 0 {
                finished(articleListModels: [JFArticleListModel](), error: nil)
                return
            }
            
            let data = result!.arrayValue
            var articleListModels = [JFArticleListModel]()
            
            // 遍历转模型添加数据
            for article in data {
                let postModel = JFArticleListModel(dict: article.dictionaryObject!)
                articleListModels.append(postModel)
            }
            
            finished(articleListModels: articleListModels, error: nil)
        }
        
    }
    
    /**
     加载搜索结果
     
     - parameter keyboard:  搜索关键词
     - parameter pageIndex: 加载分页
     - parameter finished:  数据回调
     */
    class func loadSearchResult(keyboard: String, pageIndex: Int, finished: (searchResultModels: [JFArticleListModel]?, error: NSError?) -> ()) {
        
        // 搜索不需要缓存，所以直接从网络加载
        JFNetworkTool.shareNetworkTool.loadSearchResultFromNetwork(keyboard, pageIndex: pageIndex) { (success, result, error) in
            
            // 请求失败
            if error != nil || result == nil {
                finished(searchResultModels: nil, error: error)
                return
            }
            
            // 没有数据了
            if result?.count == 0 {
                finished(searchResultModels: [JFArticleListModel](), error: nil)
                return
            }
            
            let data = result!.arrayValue
            var searchResultModels = [JFArticleListModel]()
            
            // 遍历转模型添加数据
            for article in data {
                let postModel = JFArticleListModel(dict: article.dictionaryObject!)
                searchResultModels.append(postModel)
            }
            
            finished(searchResultModels: searchResultModels, error: nil)
        }
    }
    
}