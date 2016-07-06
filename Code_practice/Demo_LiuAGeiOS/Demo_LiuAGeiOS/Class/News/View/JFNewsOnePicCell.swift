//
//  JFNewsOnePicCell.swift
//  BaoKanIOS
//
//  Created by jianfeng on 16/1/14.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage

class JFNewsOnePicCell: UITableViewCell {
    
    var postModel: ArticleListModel? {
        didSet {
            
            if postModel!.titlepic!.hasSuffix("gif") {
                iconView.image = UIImage(named: "list_placeholder")
                iconView.yy_imageURL = NSURL(string: postModel!.titlepic!)
            } else {
                iconView.yy_setImageWithURL(NSURL(string: postModel!.titlepic!), placeholder: UIImage(named: "list_placeholder"), options: YYWebImageOptions.Progressive, completion: nil)
            }
            
            articleTitleLabel.text = postModel?.title!
            timeLabel.text = postModel?.newstimeString
            befromLabel.text = postModel?.befrom!
            showNumLabel.text = postModel?.onclick!
            
            if iPhoneModel.getCurrentModel() == .iPad {
                smalltextLabel.hidden = false
                smalltextLabel.text = postModel?.smalltext!
            } else {
                smalltextLabel.hidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if iPhoneModel.getCurrentModel() == .iPad {
            articleTitleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 221
            smalltextLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 221
        } else {
            // 133 = 15(间隔) * 3(间隔数) + 88(图片宽度)
            articleTitleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 133
        }
        
    }
    
    /**
     计算行高 - 暂时这个cell高度是固定的，所以这个方法不用
     */
    func getRowHeight(postModel: ArticleListModel) -> CGFloat {
        self.postModel = postModel
        setNeedsLayout()
        layoutIfNeeded()
        
        return CGRectGetMaxY(timeLabel.frame) + 15
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var befromLabel: UILabel!
    @IBOutlet weak var showNumLabel: UILabel!
    @IBOutlet weak var smalltextLabel: UILabel!
    
}
