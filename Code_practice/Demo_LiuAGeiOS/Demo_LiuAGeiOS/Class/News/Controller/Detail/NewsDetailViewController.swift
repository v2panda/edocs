//
//  NewsDetailViewController.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/4.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import YYWebImage

// MARK: - Selector extension
private extension Selector {
    static let didTappedmoreCommentButton = #selector(NewsDetailViewController.didTappedmoreCommentButton(_:))
}


class NewsDetailViewController: UIViewController {

    var bridge: WebViewJavascriptBridge?
    
    /// 是否已经加载过webView
    var isLoaded = false
    
    /// 相关连接模型
    var otherLinks = [JFOtherLinkModel]()
    /// 评论模型
    var commentList = [JFCommentModel]()
    
    // cell标识符
    let detailContentIdentifier = "detailContentIdentifier"
    let detailStarAndShareIdentifier = "detailStarAndShareIdentifier"
    let detailOtherLinkIdentifier = "detailOtherLinkIdentifier"
    let detailCommentIdentifier = "detailCommentIdentifier"
    
    // MARK: - 属性
    var contentOffsetY: CGFloat = 0.0
    
    /// 文章详情请求参数
    var articleParam: (classid: String, id: String)? {
        didSet {
            prepareUI()
            setupWebViewJavascriptBridge()
            updateData()
        }
    }
    
    /// 详情页面模型
    var model: JFArticleDetailModel? {
        didSet {
            if !isLoaded {
                // 没有加载过，才去初始化webView - 保证只初始化一次
                loadWebViewContent(model!)
            }
            
            // 更新收藏状态
            bottomBarView.collectionButton.selected = model!.havefava == "1"
            // 相关链接
            if let links = model?.otherLinks {
                otherLinks = links
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /**
     配置WebViewJavascriptBridge
     */
    private func setupWebViewJavascriptBridge() {
        
        // 这个handle回调用来接收从JS过来给图片添加的点击事件的回调
        bridge = WebViewJavascriptBridge(forWebView: webView, webViewDelegate: self, handler: { (data, responseCallback) in
            
            responseCallback("Response for message from ObjC")
            
            guard let dict = data as! [String: AnyObject]! else {return}
            
            let index = Int(dict["index"] as! NSNumber)
            let x = CGFloat(dict["x"] as! NSNumber)
            let y = CGFloat(dict["y"] as! NSNumber) - self.tableView.contentOffset.y
            let width = CGFloat(dict["width"] as! NSNumber)
            let height = CGFloat(dict["height"] as! NSNumber)
            let url = dict["url"] as! String
            
            
            let bgView = UIView(frame: SCREEN_BOUNDS)
            bgView.backgroundColor = UIColor(red:0.110,  green:0.102,  blue:0.110, alpha:1)
            self.view.addSubview(bgView)
            
            let tempImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
            tempImageView.yy_setImageWithURL(NSURL(string: url), placeholder: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("www/images/loading.jpg", ofType: nil)!))
            self.view.addSubview(tempImageView)
            
            // 显示出图片浏览器
//            let newsPhotoBrowserVc = JFNewsPhotoBrowserViewController()
//            newsPhotoBrowserVc.transitioningDelegate = self
//            newsPhotoBrowserVc.modalPresentationStyle = .Custom
//            newsPhotoBrowserVc.photoParam = (self.model!.allphoto!, index)
//            self.presentViewController(newsPhotoBrowserVc, animated: true, completion: {})
            
            UIView.animateWithDuration(0.3, animations: {
                tempImageView.frame = CGRect(x: 0, y: (SCREEN_HEIGHT - height * (SCREEN_WIDTH / width)) * 0.5, width: SCREEN_WIDTH, height: height * (SCREEN_WIDTH / width))
                }, completion: { (_) in
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                        bgView.removeFromSuperview()
                        tempImageView.removeFromSuperview()
                    }
            })

        })
        
        
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        // 注册cell
        tableView.registerNib(UINib(nibName: "JFStarAndShareCell", bundle: nil), forCellReuseIdentifier: detailStarAndShareIdentifier)
        tableView.registerNib(UINib(nibName: "JFDetailOtherCell", bundle: nil), forCellReuseIdentifier: detailOtherLinkIdentifier)
        tableView.registerNib(UINib(nibName: "JFCommentCell", bundle: nil), forCellReuseIdentifier: detailCommentIdentifier)
        
        // 将webView添加到tableView的HeaderView
        tableView.tableHeaderView = webView
        tableView.tableFooterView = closeDetailView
        
    }
    
    /**
     请求页面数据和评论数据
     */
    private func updateData() {
        
    }

    
    
    // MARK: - 懒加载
    /// tableView - 整个容器
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        return tableView
    }()
    
    /// webView - 显示正文的
    private lazy var webView: UIWebView = {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        // 不检测网络中的格式类型
        webView.dataDetectorTypes = .None
        webView.delegate = self
        webView.scrollView.scrollEnabled = false
        return webView
    }()
    
    /// 活动指示器 - 页面正在加载时显示
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        return activityView
    }()
    
    /// 底部工具条
    private lazy var bottomBarView: JFNewsBottomBar = {
        let bottomBarView = NSBundle.mainBundle().loadNibNamed("JFNewsBottomBar", owner: nil, options: nil).last as! JFNewsBottomBar
        bottomBarView.delegate = self
        return bottomBarView
    }()
    
    /// 顶部透明白条
    private lazy var topBarView: UIView = {
        let topBarView = UIView()
        topBarView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        return topBarView
    }()
    
    /// 尾部更多评论按钮
    private lazy var footerView: UIView = {
        let moreCommentButton = UIButton(frame: CGRect(x: 20, y: 20, width: SCREEN_WIDTH - 40, height: 44))
        moreCommentButton.addTarget(self, action: #selector(didTappedmoreCommentButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        moreCommentButton.setTitle("更多评论", forState: UIControlState.Normal)
        moreCommentButton.backgroundColor = NAVIGATIONBAR_COLOR_DARK
        moreCommentButton.layer.cornerRadius = CORNER_RADIUS
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        footerView.addSubview(moreCommentButton)
        return footerView
    }()
    
    /// 尾部关闭视图
    private lazy var closeDetailView: JFCloseDetailView = {
        let closeDetailView = JFCloseDetailView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 26))
        closeDetailView.titleLabel?.font = UIFont.systemFontOfSize(15)
        closeDetailView.setTitleColor(UIColor(white: 0.2, alpha: 1), forState: UIControlState.Normal)
        closeDetailView.setTitleColor(UIColor(white: 0.2, alpha: 1), forState: UIControlState.Selected)
        closeDetailView.selected = false
        closeDetailView.setTitle("上拉关闭当前页", forState: UIControlState.Normal)
        closeDetailView.setImage(UIImage(named: "newscontent_drag_arrow"), forState: UIControlState.Normal)
        closeDetailView.setTitle("释放关闭当前页", forState: UIControlState.Selected)
        closeDetailView.setImage(UIImage(named: "newscontent_drag_return"), forState: UIControlState.Selected)
        return closeDetailView
    }()

}


// MARK: - webView相关
extension NewsDetailViewController: UIWebViewDelegate {
    
    /**
     加载webView内容
     
     - parameter model: 新闻模型
     */
    func loadWebViewContent(model: JFArticleDetailModel) {
        
    }
}

// MARK: - tableView相关
extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
}


// MARK: - 底部浮动工具条相关
extension NewsDetailViewController: JFNewsBottomBarDelegate, JFCommentCommitViewDelegate {

}

// MARK: - 评论相关
extension NewsDetailViewController: JFCommentCellDelegate {

    
    /**
     点击更多评论按钮
     */
    func didTappedmoreCommentButton(button: UIButton) -> Void {
//        let commentVc = JFCommentViewController()
//        commentVc.param = articleParam
//        navigationController?.pushViewController(commentVc, animated: true)
    }
}