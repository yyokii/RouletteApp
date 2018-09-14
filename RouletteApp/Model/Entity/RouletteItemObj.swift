//
//  RouletteItemObj.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RouletteItemObj: Object {
    @objc dynamic var colorHex = "FF9300"
    @objc dynamic var itemName = "アイテム"
    @objc dynamic var ratio: Double = 1
}
