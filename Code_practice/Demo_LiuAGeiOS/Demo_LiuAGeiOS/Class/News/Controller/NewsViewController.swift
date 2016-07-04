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

class NewsViewController: UIViewController {

    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    // 栏目数组
    private var selectedArray: [[String : String]]?
    private var optionalArray: [[String : String]]?
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initUI
        prepareUI()

        
    }
    
    // initUI
    private func prepareUI() {
        // 标题logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "navigation_logo"))
        
        // 添加内容
        addContent()
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
            
        }
    }
    
    @objc private func didTappedTopLabel(gesture: UITapGestureRecognizer) {
        
    }
    
    

}
