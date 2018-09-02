//
//  RealmManaget.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/02.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RealmManager {
    private var database: Realm?
    static let sharedInstance = RealmManager()
    
    private init() {
        database = try? Realm()
    }
    
    // MARK: - データ取得
    func getRouletteDataset() -> Results<RouletteDataset>? {
        let results: Results<RouletteDataset> = database!.objects(RouletteDataset.self)
        
        if results.count == 0 {
            return nil
        }
        return results
    }
    
    func getFavoriteDataset() -> Results<FavoriteDataset> {
        let results: Results<FavoriteDataset> =   database!.objects(FavoriteDataset.self)
        return results
    }

    // MARK: - データ追加
    func addRouletteDataset(object: RouletteDataset) {
        try? database?.write {
            database?.add(object, update: true)
            print("Added new RouletteDataset")
        }
    }
    
    func addFavoriteDataset(object: FavoriteDataset) {
        try? database?.write {
            database?.add(object, update: true)
            print("Added new FavoriteDataset")
        }
    }
    
    // MARK: - データ更新
    
    // MARK: - データ削除
    // RouletteDatasetのデータを全削除（データ内はid=1 の1件のみ）
    func deleteRouletteDataset() {
        let datasets = getRouletteDataset()
        guard datasets != nil else {
            return
        }

        datasets?.forEach { dataset in
            try? database?.write {
                database?.delete(dataset)
            }
        }
    }
    
//    func deleteAllFromDatabase() {
//        try? database?.write {
//            database?.deleteAll()
//        }
//    }
}
