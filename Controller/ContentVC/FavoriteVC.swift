//
//  FavoriteVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift
import CariocaMenu

class FavoriteVC: UIViewController, BaseVC {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var menuController: CariocaController?
    var favoriteDatasets: Results<FavoriteDataset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.register(UINib(nibName: "FavoriteItemCell", bundle: nil), forCellReuseIdentifier: "FavoriteItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteDatasets = RealmManager.sharedInstance.getFavoriteDataset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let datasetsCount = favoriteDatasets?.count {
            return datasetsCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItemCell", for: indexPath) as? FavoriteItemCell
        cell?.selectionStyle = .none
        
        if let favoriteDatasets = favoriteDatasets {
            let favoriteDataset = favoriteDatasets[indexPath.row]
            cell?.configureCell(title: favoriteDataset.titile)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("選択されたcell：\(indexPath.row)")
    }
}
