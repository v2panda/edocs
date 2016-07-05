//
//  NewsTableViewController.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import SDCycleScrollView


class NewsTableViewController: UIViewController,SDCycleScrollViewDelegate {

    /**
     分类数据
     */
    var classid:Int? {
        didSet {
            loadIsGood(classid!)
            loadNews(classid!, pageIndex: 1, method: 0)
        }
    }
    
    // 当前加载页码
    var pageIndex = 1
    // 列表模型数组
    var articleList = [
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    /**
     根据分类id加载推荐数据、作为幻灯片数据
     
     - parameter classid: 当前栏目id
     */
    private func loadIsGood(classid: Int) {
        
    }
    
    /**
     根据分类id、页码加载数据
     
     - parameter classid:   当前栏目id
     - parameter pageIndex: 当前页码
     - parameter method:    加载方式 0下拉刷新 1上拉加载更多
     */
    private func loadNews(classid: Int, pageIndex: Int, method: Int) {
        
    }
    

}
