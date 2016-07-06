//
//  NewsViewController.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Selector extension
private extension Selector {
    static let didTappedTopLabel = #selector(NewsViewController.didTappedTopLabel(_:))
}

class NewsViewController: UIViewController{

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    /// 内容区域scrollView x轴偏移量
    var contentOffsetX: CGFloat = 0.0
    // 栏目数组
    private var selectedArray: [[String : String]]?
    private var optionalArray: [[String : String]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initUI
        prepareUI()

        automaticallyAdjustsScrollViewInsets = false;
    }
    
    // initUI
    private func prepareUI() {
        
        // 移除原有数据 - 为的是排序栏目后的数据清理
        for subView in topScrollView.subviews {
            if subView.isKindOfClass(PDTopLabel.classForCoder()) {
                subView.removeFromSuperview()
            }
        }
        for  subview in contentScrollView.subviews {
            subview.removeFromSuperview()
        }
        for vc in childViewControllers {
            vc.removeFromParentViewController()
        }
        
        // 添加内容
        addContent()
    }
    
    
    /**
     配置栏目按钮点击
     */
    @IBAction func didTappedArrowButton(sender: UIButton) {
        print(233)
        
    }

    
    /**
     初始化栏目
     */
    private func setupColumn() {
        let tempSelectedArray = USER_DEFAULTS.objectForKey(SELECTED_ARRAY) as? [[String : String]]
        let tempOptionalArray = USER_DEFAULTS.objectForKey(OPTIONAL_ARRAY) as? [[String : String]]
        
        if tempSelectedArray != nil || tempOptionalArray != nil{
            
            selectedArray = tempSelectedArray != nil ? tempSelectedArray : [[String : String]]()
            optionalArray = tempOptionalArray != nil ? tempOptionalArray : [[String : String]]()
            
        }else {
            // 默认栏目顺序 - 可以直接存plist文件
            selectedArray = [
                [
                    "classid" : "0",
                    "classname" : "今日推荐"
                ],
                [
                    "classid" : "1",
                    "classname": "奇闻异事"
                ],
                [
                    "classid" : "2",
                    "classname": "未解之谜"
                ],
                [
                    "classid" : "3",
                    "classname": "天文航天"
                ],
                [
                    "classid" : "4",
                    "classname": "UTO探索"
                ],
                [
                    "classid" : "5",
                    "classname": "神奇地球"
                ],
                [
                    "classid" : "7",
                    "classname": "震惊事件"
                ],
                [
                    "classid" : "9",
                    "classname": "灵异恐怖"
                ]
            ]
            
            optionalArray = [
                [
                    "classid" : "8",
                    "classname": "迷案追踪"
                ],
                [
                    "classid" : "10",
                    "classname": "历史趣闻"
                ],
                [
                    "classid" : "11",
                    "classname": "军事秘闻"
                ],
                [
                    "classid" : "12",
                    "classname": "科学探秘"
                ],
                [
                    "classid" : "13",
                    "classname": "动物植物"
                ],
                [
                    "classid" : "14",
                    "classname": "自然地理"
                ],
                [
                    "classid" : "15",
                    "classname": "内涵趣图"
                ],
                [
                    "classid" : "16",
                    "classname": "爆笑段子"
                ]
            ]
            
            // 默认栏目保存
            USER_DEFAULTS.setObject(selectedArray, forKey: SELECTED_ARRAY)
            USER_DEFAULTS.setObject(optionalArray, forKey: OPTIONAL_ARRAY)
        }
        
        
    }

    
    /**
     添加顶部标题栏和控制器
     */
    private func addContent()  {
        // 初始化栏目
        setupColumn()
        
        contentScrollView.pagingEnabled = true
        
        // 布局用的左边距
        var leftMargin:CGFloat = 0
        
        for i in 0 ..< selectedArray!.count {
            let label = PDTopLabel()
            label.text = selectedArray![i]["classname"]
            label.tag = i
            label.scale = i == 0 ? 1.0 : 0.0
            label.userInteractionEnabled = true
            topScrollView.addSubview(label)
            
            // 利用layout来自适应各种长度的label
            label.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(leftMargin + 15)
                make.centerY.equalTo(topScrollView)
            })
            
            // 实时更新布局和左边距
            topScrollView.layoutIfNeeded()
            leftMargin = CGRectGetMaxX(label.frame)
            
            // 添加标签点击手势
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .didTappedTopLabel))
            
            // 添加控制器
            let newVC = NewsTableViewController()
            addChildViewController(newVC)
            
            // 默认控制器 和 预加载的一个控制器
            if i <= 1 {
                
                addContentViewController(i)
                
                if i == 0 {
                    // 给第一个列表控制器的视图添加手势 - 然后在手势代理里面处理手势冲突
                    // tableView自带pan手势，如果不处理，我们添加的手势会覆盖默认手势
                    // TODO::
                    
                }
            }
        }
        // 内容区域滚动范围
        contentScrollView.contentSize = CGSizeMake(CGFloat(childViewControllers.count) * SCREEN_WIDTH, 0)
        
        let lastLabel = topScrollView.subviews.last as! PDTopLabel
        // 设置顶部标签区域滚动范围
        topScrollView.contentSize = CGSize(width: leftMargin + lastLabel.frame.width, height: 0)
        
        // 视图滚动到第一个位置
        contentScrollView.setContentOffset(CGPoint(x: 0, y: contentScrollView.contentOffset.y), animated: true)
        
    }
    
    /**
     添加内容控制器
     
     - parameter index: 控制器角标
     */
    private func addContentViewController(index : Int) {
        
        // 获取需要展示的控制器
        let newVC = childViewControllers[index] as! NewsTableViewController
        
        // 如果已经展示则直接返回
        if newVC.view.superview != nil {
            return
        }
        
        newVC.view.frame = CGRect(x: CGFloat(index) * SCREEN_WIDTH, y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
        contentScrollView.addSubview(newVC.view)
        newVC.classid = Int(selectedArray![index]["classid"]!)
    }
    
    /**
     顶部标签的点击事件
     */
    @objc private func didTappedTopLabel(gesture: UITapGestureRecognizer) {
        let titleLabel = gesture.view as! PDTopLabel
        // 让内容视图滚动到指定的位置
        contentScrollView.setContentOffset(CGPointMake(CGFloat(titleLabel.tag) * contentScrollView.frame.size.width, contentScrollView.contentOffset.y ), animated: true)
    }
    

}


// MARK: - scrollView代理方法
extension NewsViewController: UIScrollViewDelegate {
    
    // 滚动结束后触发 
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        // 滚动标题栏
        let titleLabel = topScrollView.subviews[index]
        var offsetX = titleLabel.center.x - topScrollView.frame.size.width * 0.5
        let offsetMax = topScrollView.contentSize.width - topScrollView.frame.size.width
        
        if offsetX < 0 {
            offsetX = 0
        } else if offsetX > offsetMax {
            offsetX = offsetMax
        }
        
        // 滚动顶部标题
        topScrollView.setContentOffset(CGPoint(x: offsetX, y: topScrollView.contentOffset.y), animated: true)
        
        // 恢复其它label缩放
        for i in 0..<selectedArray!.count {
            if i != index {
                let topLabel = topScrollView.subviews[i] as! PDTopLabel
                topLabel.scale = 0.0
            }
        }
        
        // 添加控制器 - 并预加载控制器  左滑预加载下下个 右滑预加载上上个 保证滑动流畅
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        var index1 = Int(value)
        var index2 = Int(value)
        
        // 根据滑动方向计算下标
        if scrollView.contentOffset.x - contentOffsetX > 2.0 {
            index1 = (value - CGFloat(Int(value))) > 0 ? Int(value) + 1 : Int(value)
            index2 = index1 + 1
        } else if contentOffsetX - scrollView.contentOffset.x > 2.0 {
            index1 = (value - CGFloat(Int(value))) < 0 ? Int(value) - 1 : Int(value)
            index2 = index1 - 1
        }
        
        // 控制器角标范围
        if index1 > childViewControllers.count - 1 {
            index1 = childViewControllers.count - 1
        } else if index1 < 0 {
            index1 = 0
        }
        if index2 > childViewControllers.count - 1 {
            index2 = childViewControllers.count - 1
        } else if index2 < 0 {
            index2 = 0
        }
        
        addContentViewController(index1)
        addContentViewController(index2)
        
    }
    
    // 手势导致滚动结束
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // 开始拖拽视图
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        contentOffsetX = scrollView.contentOffset.x
    }
    
    // 正在滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        let leftIndex = Int(value)
        let rightIndex = leftIndex + 1
        let scaleRight = value - CGFloat(leftIndex)
        let scaleLeft = 1 - scaleRight
        
        let labelLeft = topScrollView.subviews[leftIndex] as! PDTopLabel
        labelLeft.scale = scaleLeft
        
        if rightIndex <  topScrollView.subviews.count {
            let labelRight =  topScrollView.subviews[rightIndex] as! PDTopLabel
            labelRight.scale = scaleRight
        }
    }
    
    
}


























