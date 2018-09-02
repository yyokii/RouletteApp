//
//  RouletteDataset.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation

class RouletteDataset {
    var title: String?
    var items: [RouletteItemObj]
    
    // シングルトン → シングルトン却下で
    static let sharedInstance: RouletteDataset = RouletteDataset(title: "ルーレット👍", items: [])
    // initを通るのは最初だけ
    private init(title: String?, items: [RouletteItemObj]) {
        self.title = title
        self.items = items
    }
}
