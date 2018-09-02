//
//  FavoriteLabel.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class FavoriteLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notFavorite()
    }
    
    func notFavorite() {
        self.alpha = 0.3
    }
    
    func favorite() {
        self.alpha = 1
    }
}
