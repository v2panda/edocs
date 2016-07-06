//
//  NewsTableViewController.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh


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
    var articleList = [ArticleListModel]()
    /// 幻灯片模型数组
    var isGoodList = [ArticleListModel]()
    /// 顶部轮播
    var topScrollView: SDCycleScrollView!
    
    /// 新闻cell重用标识符 无图、单图、三图
    let newsNoPicCell = "newsNoPicCell"
    let newsOnePicCell = "newsOnePicCell"
    let newsThreePicCell = "newsThreePicCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
    }

    /**
     准备tableView
     */
    private func prepareTableView() {
        view.addSubview(tableView)
        view.addSubview(placeholderView)
        placeholderView.startAnimation()
        
        // 注册cell
        tableView.registerNib(UINib(nibName: "JFNewsNoPicCell", bundle: nil), forCellReuseIdentifier: newsNoPicCell)
        tableView.registerNib(UINib(nibName: "JFNewsOnePicCell", bundle: nil), forCellReuseIdentifier: newsOnePicCell)
        tableView.registerNib(UINib(nibName: "JFNewsThreePicCell", bundle: nil), forCellReuseIdentifier: newsThreePicCell)
        
        // 配置上下拉刷新控件
        tableView.mj_header = setupHeaderRefresh(self, action: #selector(updateNewData))
        tableView.mj_footer = setupFooterRefresh(self, action: #selector(loadMoreData))
    
    }
    /**
     准备tableHeaderView轮播
     */
    private func prepareScrollView() {
        topScrollView = SDCycleScrollView(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.3), delegate:self, placeholderImage:UIImage(named: "photoview_image_default_white"))
        topScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        topScrollView.pageDotColor = NAVIGATIONBAR_COLOR
        topScrollView.currentPageDotColor = UIColor.blackColor()
        
        // 过滤无图崩溃
        var images = [String]()
        var titles = [String]()
        
        for index in 0..<isGoodList.count {
            if isGoodList[index].titlepic != nil {
                images.append(isGoodList[index].titlepic!)
                titles.append(isGoodList[index].title!)
            }
        }
        if images.count == 0 {
            return
        }
        
        topScrollView.imageURLStringsGroup = images
        topScrollView.titlesGroup = titles
        topScrollView.autoScrollTimeInterval = 5
        tableView.tableHeaderView = topScrollView
    
    }
    
    
    /**
     根据分类id加载推荐数据、作为幻灯片数据
     
     - parameter classid: 当前栏目id
     */
    private func loadIsGood(classid: Int) {
        
        ArticleListModel.loadNewsList(classid, pageIndex: pageIndex, type: 2, cache: true) { (articleListModels, error) in
            guard let list = articleListModels where error != true else {
                return
            }
            
            self.isGoodList = list
            
            // 更新轮播图
            self.prepareScrollView()
            
        }
    }
    
    /**
     根据分类id、页码加载数据
     
     - parameter classid:   当前栏目id
     - parameter pageIndex: 当前页码
     - parameter method:    加载方式 0下拉刷新 1上拉加载更多
     */
    private func loadNews(classid: Int, pageIndex: Int, method: Int) {
        ArticleListModel.loadNewsList(classid, pageIndex: pageIndex, type: 1, cache: true) { (articleListModels, error) in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            guard let list = articleListModels where error != true else {
                return
            }
            
            if list.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                
                if self.articleList.count == 0 {
                    self.placeholderView.noAnyData("还没有任何资讯")
                }
                return
            }
            
            // id越大，文章越新
            // ??空值运算符  id不为nil则解包，否则返回"0"
            let maxId = self.articleList.first?.id ?? "0"
            let minId = self.articleList.last?.id ?? "0"
            
            if method == 0 {
                // 0下拉加载最新 - 会直接覆盖数据，用最新的10条数据
                if Int(maxId) < Int(list[0].id!) {
                    self.articleList = list
                }
            } else {
                // 1上拉加载更多 - 拼接数据
                if Int(minId) > Int(list[0].id!) {
                    self.articleList = self.articleList + list
                } else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
            self.placeholderView.removeAnimation()
            self.tableView.reloadData()
        }

    }
    
    
    // MARK: - 网络请求
    /**
     下拉加载最新数据
     */
    @objc private func updateNewData() {
        
        // 有网络的时候下拉会自动清除缓存
        if true {
            ArticleListModel.cleanCache(classid!)
        }
        
        loadNews(classid!, pageIndex: 1, method: 0)
        
        // 只有下拉的时候才去加载幻灯片数据
        loadIsGood(classid!)
    }
    
    /**
     上拉加载更多数据
     */
    @objc private func loadMoreData() {
        pageIndex += 1
        loadNews(classid!, pageIndex: pageIndex, method: 1)
    }

    
    
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        
        let currentListModel = isGoodList[index]
        jumpToDetailViewControllerWith(currentListModel)
    }
    
    /**
     根据当前列表模型跳转到指定控制器
     
     - parameter currentListModel: 模型
     */
    private func jumpToDetailViewControllerWith(currentListModel: ArticleListModel) {
        
        // 如果是多图就跳转到图片浏览器
        if currentListModel.morepic?.count == 3 {
            print("还没写呢")
//            let photoDetailVc = JFPhotoDetailViewController()
//            photoDetailVc.photoParam = (currentListModel.classid!, currentListModel.id!)
//            navigationController?.pushViewController(photoDetailVc, animated: true)
        } else {
            let articleDetailVc = NewsDetailViewController()
            articleDetailVc.articleParam = (currentListModel.classid!, currentListModel.id!)
            navigationController?.pushViewController(articleDetailVc, animated: true)
        }
    }

    /**
     *  tableView
     */
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 104), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red:0.9,  green:0.9,  blue:0.9, alpha:1)
        return tableView
    }()
    
    /// 没有内容的时候的占位图
    private lazy var placeholderView: JFPlaceholderView = {
        let placeholderView = JFPlaceholderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 104))
        placeholderView.backgroundColor = UIColor.whiteColor()
        return placeholderView
    }()

}

// MARK: - Table view data source
extension NewsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let postModel = articleList[indexPath.row]
        if postModel.titlepic == "" { // 无图
            if postModel.rowHeight == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(newsNoPicCell) as! JFNewsNoPicCell
                let height = cell.getRowHeight(postModel)
                postModel.rowHeight = height
            }
            return postModel.rowHeight
        } else if postModel.morepic?.count == 0 { // 单图

                return 96
            
        } else { // 多图
            if postModel.rowHeight == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(newsThreePicCell) as! JFNewsThreePicCell
                let height = cell.getRowHeight(postModel)
                postModel.rowHeight = height
            }
            return postModel.rowHeight
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let postModel = articleList[indexPath.row]
        
        if postModel.titlepic == "" { // 无图
            let cell = tableView.dequeueReusableCellWithIdentifier(newsNoPicCell) as! JFNewsNoPicCell
            cell.postModel = postModel
            return cell
        } else if postModel.morepic?.count == 0 { // 单图
            let cell = tableView.dequeueReusableCellWithIdentifier(newsOnePicCell) as! JFNewsOnePicCell
            cell.postModel = postModel
            return cell
        } else { // 多图
            let cell = tableView.dequeueReusableCellWithIdentifier(newsThreePicCell) as! JFNewsThreePicCell
            cell.postModel = postModel
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 取消cell选中状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // 跳转控制器
        let currentListModel = articleList[indexPath.row]
        jumpToDetailViewControllerWith(currentListModel)
    }


}
