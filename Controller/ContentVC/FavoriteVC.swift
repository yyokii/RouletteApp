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
import PopupDialog

class FavoriteVC: UIViewController, BaseVC {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    var menuController: CariocaController?
    var favoriteDatasets: Results<RouletteDataset>?
    
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
        guard let favorites = favoriteDatasets else {
            return
        }
        let selectedDataset = favorites[indexPath.row]
        PopupDialogManager.showOkCancelDialog(vc: self, title: "「\(selectedDataset.titile)」をルーレットに設定しますか？", message: "「OK」を選択するとルーレットにデータが反映されます", cancelTapped: {}, okTapped: {
            let copyOfDataset = RealmManager.sharedInstance.copyOfRouletteDataset(dataset: selectedDataset)
            RealmManager.sharedInstance.setDataset = copyOfDataset
        }, completion: nil)
    }
}
