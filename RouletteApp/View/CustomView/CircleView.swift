//
//  CircleView.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
