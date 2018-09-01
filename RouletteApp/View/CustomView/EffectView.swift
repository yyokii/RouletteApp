//
//  EffectView.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class EffectView: UIVisualEffectView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
