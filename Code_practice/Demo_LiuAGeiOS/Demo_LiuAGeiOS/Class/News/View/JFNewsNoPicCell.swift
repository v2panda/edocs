//
//  JFNewsNoPicCell.swift
//  BaoKanIOS
//
//  Created by jianfeng on 16/1/14.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit
import YYWebImage

class JFNewsNoPicCell: UITableViewCell {
    
    var postModel: ArticleListModel? {
        didSet {
            articleTitleLabel.text = postModel?.title!.timeStampTpString()
            timeLabel.text = postModel?.newstimeString
            befromLabel.text = postModel?.befrom!
            showNumLabel.text = postModel?.onclick!
        }
    }
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var befromLabel: UILabel!
    @IBOutlet weak var showNumLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        articleTitleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30
    }
    
    /**
     计算行高
     */
    func getRowHeight(postModel: ArticleListModel) -> CGFloat {
        self.postModel = postModel
        setNeedsLayout()
        layoutIfNeeded()
        return CGRectGetMaxY(timeLabel.frame) + 15
    }
}
