//
//  RouletteDataset.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import RealmSwift

/// １つ分のデータセット（realmで保存する）
class RouletteDataset: Object {
    @objc dynamic var id = 1
    @objc dynamic var titile = "ルーレット👍"
    var items = List<RouletteItemObj>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

/// お気に入りデータ（realmで保存する）
class FavoriteDataset: Object {
    @objc dynamic var titile = "ルーレット👍"
    var items = List<RouletteItemObj>()
}
