//
//  RealmManaget.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/02.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RealmManager {
    static let sharedInstance = RealmManager()
    private var database: Realm?
    // 現在設定されているデータセット
    var setDataset: RouletteDataset?
    
    private init() {
        database = try? Realm()
    }
    
    /// RouletteDatasetのコピーを作成
    ///
    /// - Parameter dataset: managedなオブジェクト
    /// - Returns: コピーオブジェクト
    func copyOfRouletteDataset(dataset: RouletteDataset) -> RouletteDataset {
        let rouletteDataset = RouletteDataset()
        // コピーオブジェクトを作成
        let copyTitle = dataset.titile
        rouletteDataset.titile = copyTitle
        
        let copyItems = List<RouletteItemObj>()
        for item in dataset.items {
            copyItems.append(RouletteItemObj(value: item))
        }
        rouletteDataset.items = copyItems
        
        return rouletteDataset
    }
    
    // 現在設定されているデータセットを更新する
    func updateSetDataset(dataset: RouletteDataset) {
        self.setDataset = dataset
    }
    
    func addRouletteDataset(object: RouletteDataset) {
        try? database?.write {
            database?.add(object)
            print("RouletteDatasetに追加しました")
        }
    }
    
    func getFavoriteDataset() -> Results<RouletteDataset>? {
        let results = database!.objects(RouletteDataset.self)
        return results
    }
    
    func deleteFavoriteDataset(object: RouletteDataset) {
        try? database?.write {
            database?.delete(object)
            print("RouletteDatasetを１つ削除しました")
        }
    }
}
