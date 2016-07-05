//
//  PDTopLabel.swift
//  Demo_LiuAGeiOS
//
//  Created by Panda on 16/7/4.
//  Copyright © 2016年 v2panda. All rights reserved.
//

import UIKit

class PDTopLabel: UILabel {

    var scale : CGFloat? {
        didSet {
            // 通过scale来改变各种参数
            // 产生缩放动画效果
            textColor = UIColor.colorWithRGB(231, g: 129, b: 112)
            let minScale : CGFloat = 0.9
            let trueScale : CGFloat = minScale + (1 - minScale) * scale!
            transform = CGAffineTransformMakeScale(trueScale, trueScale)
        }
    }
    
    //MARK: -  构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .Center
        font = UIFont.systemFontOfSize(20)
    }
    
}
