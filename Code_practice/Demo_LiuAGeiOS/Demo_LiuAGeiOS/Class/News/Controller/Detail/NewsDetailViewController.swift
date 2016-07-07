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
        // 即 触发JS方法 OC端做出反应
        // 通过WebViewJavascriptBridge来实现
        bridge = WebViewJavascriptBridge(forWebView: webView, webViewDelegate: self, handler: { (data, responseCallback) in
            
            responseCallback("Response for message from ObjC")
            
            guard let dict = data as! [String: AnyObject]! else {return}
            
            let index = Int(dict["index"] as! NSNumber)
            let x = CGFloat(dict["x"] as! NSNumber)
            let y = CGFloat(dict["y"] as! NSNumber) - self.tableView.contentOffset.y
            let width = CGFloat(dict["width"] as! NSNumber)
            let height = CGFloat(dict["height"] as! NSNumber)
            let url = dict["url"] as! String
            
            
            // 先放背景图 和 图片占位  
            // 推出图片浏览器后 移除背景图和占位图
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
        // closeDetailView是一个button 控制button.selected属性
        tableView.tableFooterView = closeDetailView
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
        view.addSubview(activityView)
        activityView.startAnimating()
        
        activityView.snp_makeConstraints { (make) in
            make.center.equalTo(view)
        }
        topBarView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(20)
        }
        bottomBarView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(45)
        }
    }
    
    /**
     请求页面数据和评论数据
     */
    private func updateData() {
        loadNewsDetail(Int(articleParam!.classid)!, id: Int(articleParam!.id)!)
//        loadCommentList(Int(articleParam!.classid)!, id: Int(articleParam!.id)!)
    }

    
    /**
     加载正文数据
     
     - parameter classid: 当前子分类id
     - parameter id:      文章id
     */
    func loadNewsDetail(classid: Int, id: Int) {
        JFArticleDetailModel.loadNewsDetail(classid, id: id, cache: true) { (articleDetailModel, error) in
            guard let model = articleDetailModel where error == nil else {return}
            
            // 获取新闻详情数据
            self.model = model
            self.tableView.reloadData()
        }
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
//        bottomBarView.delegate = self
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
     webView加载完成后更新webView高度并刷新tableView
     */
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // 调用JS方法计算webView的高度
        autolayoutWebView()
    }
    
    /**
     自动布局webView
     */
    func autolayoutWebView() {
        // webview执行js里预先写好的方法
        let result = webView.stringByEvaluatingJavaScriptFromString("getHtmlHeight();")
        if let height = result {
            webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGFloat((height as NSString).floatValue) + 20)
            tableView.tableHeaderView = webView
            self.activityView.stopAnimating()
        }
    }
    
    /**
     过滤html，有需要过滤的直接写到这个方法
     
     - parameter string: 过滤前的html
     
     - returns: 过滤后的html
     */
    func filterHTML(string: String) -> String {
        return (string as NSString).stringByReplacingOccurrencesOfString("<p>&nbsp;</p>", withString: "")
    }
    
    /**
     加载webView内容
     
     - parameter model: 新闻模型
     */
    func loadWebViewContent(model: JFArticleDetailModel) {
        
        // &nbsp 空格占位符
        var html = ""
        html += "<div class=\"title\">\(model.title!)</div>"
        html += "<div class=\"time\">\(model.befrom!)&nbsp;&nbsp;&nbsp;&nbsp;\(model.newstime!.timeStampTpString())</div>"
        
        // 临时正文 - 这样做的目的是不修改模型
        var tempNewstext = model.newstext!
        
        // 有图片才去拼接图片
        if model.allphoto!.count > 0 {
            
            // 拼接图片标签
            for (index, dict) in model.allphoto!.enumerate() {
                // 图片占位符范围
                // 获取图片占位符的范围 即类似<!--IMG#0--> 在model.newstext的位置
                let range = (tempNewstext as NSString).rangeOfString(dict["ref"] as! String)
                
                // 默认宽、高为0
                var width: CGFloat = 0
                var height: CGFloat = 0
                if let w = dict["pixel"]!!["width"] as? NSNumber {
                    width = CGFloat(w.floatValue)
                }
                if let h = dict["pixel"]!!["height"] as? NSNumber  {
                    height = CGFloat(h.floatValue)
                }
                
                // 如果图片超过了最大宽度，才等比压缩 这个最大宽度是根据css里的container容器宽度来自适应的
                if width >= SCREEN_WIDTH - 40 {
                    let rate = (SCREEN_WIDTH - 40) / width
                    width = width * rate
                    height = height * rate
                }
                
                // 加载中的占位图
                let loading = NSBundle.mainBundle().pathForResource("www/images/loading.jpg", ofType: nil)!
                
                // 图片URL
                let imgUrl = dict["url"] as! String
                
                // 在img标签中添加一个id并赋值图片的url，用于标识图片，这个id用作唯一标识符
                // 最终会替换掉img标签的对应src值，传递下载完成后的图片路径
                // 给图片添加onclick方法 - didTappedImage
                let imgTag = "<img onclick='didTappedImage(\(index), \"\(imgUrl)\");' src='\(loading)' id='\(imgUrl)' width='\(width)' height='\(height)' />"
                
                // 使用带loading占位图的img标签，替换掉类似<!--IMG#0-->原有标识符
                tempNewstext = (tempNewstext as NSString).stringByReplacingOccurrencesOfString(dict["ref"] as! String, withString: imgTag, options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
            }
            
            // 加载图片 - 从缓存中获取图片的本地绝对路径，发送给webView显示
            getImageFromDownloaderOrDiskByImageUrlArray(model.allphoto!)
        }
        
        let fontSize = NSUserDefaults.standardUserDefaults().integerForKey(CONTENT_FONT_SIZE_KEY)
        let fontName = NSUserDefaults.standardUserDefaults().stringForKey(CONTENT_FONT_TYPE_KEY)!
        
        html += "<div id=\"content\" style=\"font-size: \(fontSize)px; font-family: '\(fontName)';\">\(tempNewstext)</div>"
        
        // 从本地加载网页模板，替换新闻主页
        let templatePath = NSBundle.mainBundle().pathForResource("www/html/article.html", ofType: nil)!
        let template = (try! String(contentsOfFile: templatePath, encoding: NSUTF8StringEncoding)) as NSString
        
        html = template.stringByReplacingOccurrencesOfString("<p>mainnews</p>", withString: html, options: NSStringCompareOptions.CaseInsensitiveSearch, range: template.rangeOfString("<p>mainnews</p>"))
        let baseURL = NSURL(fileURLWithPath: templatePath)
        
        // 加载
        webView.loadHTMLString(filterHTML(html), baseURL: baseURL)
        
        // 已经加载过就修改标记
        isLoaded = true
    }
    
    /**
     下载或从缓存中获取图片，发送给webView
     */
    func getImageFromDownloaderOrDiskByImageUrlArray(imageArray: [AnyObject]) {
        
        // 循环加载图片
        for dict in imageArray {
            
            // 图片url
            let imageString = dict["url"] as! String
            
            // 判断本地磁盘是否已经缓存
            if JFArticleStorage.getArticleImageCache().containsImageForKey(imageString, withType: YYImageCacheType.Disk) {
                
                let imagePath = JFArticleStorage.getFilePathForKey(imageString)
                // 发送图片占位标识和本地绝对路径给webView
                bridge?.send("replaceimage\(imageString)~\(imagePath)")
                //                print("图片已有缓存，发送给js \(imagePath)")
            } else {
                YYWebImageManager(cache: JFArticleStorage.getArticleImageCache(), queue: NSOperationQueue()).requestImageWithURL(NSURL(string: imageString)!, options: YYWebImageOptions.UseNSURLCache, progress: { (_, _) in
                    }, transform: { (image, url) -> UIImage? in
                        return image
                    }, completion: { (image, url, type, stage, error) in
                        
                        // 当刚缓存完成的图片，还没来得及存储到本地，所以有时候会从本地加载不到图片。需要延迟
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                            // 确保已经下载完成并没有出错 - 这样做其实已经修改了YYWebImage的磁盘缓存策略。默认YYWebImage缓存文件时超过20kb的文件才会存储为文件，所以需要在 YYDiskCache.m的171行修改
                            guard let _ = image where error == nil else {return}
                            let imagePath = JFArticleStorage.getFilePathForKey(imageString)
                            // 发送图片占位标识和本地绝对路径给webView
                            self.bridge?.send("replaceimage\(imageString)~\(imagePath)")
                            //                            print("图片缓存完成，发送给js \(imagePath)")
                        }
                        
                })
            }
            
        }
    }
}

// MARK: - tableView相关
extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 这样做是为了防止还没有数据的时候滑动崩溃哦
        return model == nil ? 0 : 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 分享
            return 1
        case 1: // 广告
            return 1
        case 2: // 相关阅读
            return otherLinks.count
        case 3: // 评论、最多显示10条
            return commentList.count >= 10 ? 10 : commentList.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // 分享
            let cell = self.tableView.dequeueReusableCellWithIdentifier(self.detailStarAndShareIdentifier) as! JFStarAndShareCell
            cell.delegate = self
            cell.befromLabel.text = "文章来源: \(model!.befrom!)"
            cell.selectionStyle = .None
            return cell
        case 1: // 广告
            let cell = UITableViewCell()
            cell.selectionStyle = .None
            let adImageView = UIImageView(frame: CGRect(x: 12, y: 0, width: SCREEN_WIDTH - 24, height: SCREEN_HEIGHT * 0.2))
            adImageView.image = UIImage(named: "temp_ad")
            cell.contentView.addSubview(adImageView)
            return cell
        case 2: // 相关阅读
            let cell = tableView.dequeueReusableCellWithIdentifier(detailOtherLinkIdentifier) as! JFDetailOtherCell
            cell.model = otherLinks[indexPath.row]
            return cell
        case 3: // 评论
            let cell = tableView.dequeueReusableCellWithIdentifier(detailCommentIdentifier) as! JFCommentCell
            cell.delegate = self
            cell.commentModel = commentList[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }

    // 组头
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // 相关阅读和最新评论才需要创建组头
        if section == 2 || section == 3 {
            
            // 屎黄色竖线
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 30))
            leftView.backgroundColor = NAVIGATIONBAR_COLOR
            
            // 灰色背景
            let bgView = UIView(frame: CGRect(x: 3, y: 0, width: SCREEN_WIDTH - 3, height: 30))
            bgView.backgroundColor = UIColor(red:0.914,  green:0.890,  blue:0.847, alpha:0.3)
            
            // 组头名称
            let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 100, height: 30))
            
            // 组头容器 （因为组头默认是和cell一样宽，高度也是委托方法里返回，所以里面的子控件才需要布局）
            let headerView = UIView()
            headerView.addSubview(leftView)
            headerView.addSubview(bgView)
            headerView.addSubview(titleLabel)
            
            if section == 2 {
                titleLabel.text = "相关阅读"
                return otherLinks.count == 0 ? nil : headerView
            } else {
                titleLabel.text = "最新评论"
                return commentList.count == 0 ? nil : headerView
            }
            
        } else {
            return nil
        }
    }
    
    // 组尾
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3 {
            // 如果有评论信息就添加更多评论按钮 超过10条才显示更多评论
            return commentList.count >= 10 ? footerView : nil // 如果有评论才显示更多评论按钮
        } else {
            return nil
        }
    }
    
    // cell高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: // 分享
            return 160
        case 1: // 广告
            return SCREEN_HEIGHT * 0.2
        case 2: // 相关阅读
            return 100
        case 3: // 评论
            var rowHeight = commentList[indexPath.row].rowHeight
            if rowHeight < 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(detailCommentIdentifier) as! JFCommentCell
                // 缓存评论cell高度 ,将缓存的高度存到model中去
                commentList[indexPath.row].rowHeight = cell.getCellHeight(commentList[indexPath.row])
                rowHeight = commentList[indexPath.row].rowHeight
            }
            return rowHeight
        default:
            return 0
        }
    }
    
    // 组头高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        case 1:
            return 10
        case 2:
            return otherLinks.count == 0 ? 1 : 30
        case 3:
            return commentList.count == 0 ? 1 : 35
        default:
            return 1
        }
    }
    
    // 组尾高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        case 1:
            return 15
        case 2:
            return otherLinks.count == 0 ? 1 : 15
        case 3:
            return commentList.count == 10 ? 100 : 20
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 2 {
            let otherModel = otherLinks[indexPath.row]
            let detailVc = NewsDetailViewController()
            detailVc.articleParam = (otherModel.classid!, otherModel.id!)
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
}

// MARK: - 分享相关
extension NewsDetailViewController: JFStarAndShareCellDelegate {
    /**
     点击QQ
     */
    func didTappedQQButton(button: UIButton) {
//        shareWithType(SSDKPlatformType.SubTypeQQFriend)
    }
    
    /**
     点击了微信
     */
    func didTappedWeixinButton(button: UIButton) {
//        shareWithType(SSDKPlatformType.SubTypeWechatSession)
    }
    
    /**
     点击了朋友圈
     */
    func didTappedFriendCircleButton(button: UIButton) {
//        shareWithType(SSDKPlatformType.SubTypeWechatTimeline)
    }

}


// MARK: - 底部浮动工具条相关
extension NewsDetailViewController {

    // 开始拖拽视图
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
    }
    
    // 松手后触发
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        // 这里实现上拉关闭当前页
        if (scrollView.contentOffset.y + SCREEN_HEIGHT) > scrollView.contentSize.height {
            if (scrollView.contentOffset.y + SCREEN_HEIGHT) - scrollView.contentSize.height >= 50 {
                
                UIGraphicsBeginImageContext(SCREEN_BOUNDS.size)
                UIApplication.sharedApplication().keyWindow?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                
                // 在window上层添加 一张当前屏幕截图
                let tempImageView = UIImageView(image: UIGraphicsGetImageFromCurrentImageContext())
                UIApplication.sharedApplication().keyWindow?.addSubview(tempImageView)
                
                // 返回前一界面 关闭动画
                navigationController?.popViewControllerAnimated(false)
                
                // 动画
                UIView.animateWithDuration(0.3, animations: {
                    tempImageView.alpha = 0
                    tempImageView.frame = CGRect(x: 0, y: SCREEN_HEIGHT * 0.5, width: SCREEN_WIDTH, height: 0)
                    }, completion: { (_) in
                        tempImageView.removeFromSuperview()
                })
                
            }
        }
    }
    
    /**
     手指滑动屏幕开始滚动
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView.dragging) {
            if scrollView.contentOffset.y - contentOffsetY > 5.0 {
                // 向上拖拽 隐藏
                UIView.animateWithDuration(0.25, animations: {
                    self.bottomBarView.transform = CGAffineTransformMakeTranslation(0, 44)
                })
            } else if contentOffsetY - scrollView.contentOffset.y > 5.0 {
                UIView.animateWithDuration(0.25, animations: {
                    self.bottomBarView.transform = CGAffineTransformIdentity
                })
            }
            
        }
        
        if (scrollView.contentOffset.y + SCREEN_HEIGHT) > scrollView.contentSize.height {
            if (scrollView.contentOffset.y + SCREEN_HEIGHT) - scrollView.contentSize.height >= 50 {
                closeDetailView.selected = true
            } else {
                closeDetailView.selected = false
            }
        }
        
    }
    
    /**
     滚动减速结束
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // 滚动到底部后 显示
        if case let space = scrollView.contentOffset.y + SCREEN_HEIGHT - scrollView.contentSize.height where space > -5 && space < 5 {
            UIView.animateWithDuration(0.25, animations: {
                self.bottomBarView.transform = CGAffineTransformIdentity
            })
        }
    }


}

// MARK: - 评论相关
extension NewsDetailViewController: JFCommentCellDelegate {

    /**
     点击了评论cell上的赞按钮
     */
    func didTappedStarButton(button: UIButton, commentModel: JFCommentModel) {
        
    }
    
    /**
     点击更多评论按钮
     */
    func didTappedmoreCommentButton(button: UIButton) -> Void {
//        let commentVc = JFCommentViewController()
//        commentVc.param = articleParam
//        navigationController?.pushViewController(commentVc, animated: true)
    }
}