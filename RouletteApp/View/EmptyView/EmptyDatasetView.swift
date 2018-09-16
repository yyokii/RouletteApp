//
//  EmptyDatasetView.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/16.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class EmptyDatasetView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        let view = Bundle.main.loadNibNamed("EmptyDatasetView", owner: self, options: nil)?.first as? UIView
        view?.frame = self.bounds
        self.addSubview(view!)
    }
}
