//
//  RouletteDataset.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RouletteDataset: Object {
    @objc dynamic var titile = "ルーレット"
    var items = List<RouletteItemObj>()
}
