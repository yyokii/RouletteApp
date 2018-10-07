//
//  FavoriteVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import CariocaMenu
import PopupDialog
import RealmSwift
import PopupDialog
import ViewAnimator

class FavoriteVC: UIViewController, BaseVC {
    @IBOutlet weak var emptyFavoriteView: EmptyFavoriteView!
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
        checkViewVisibility()
    }

    override func viewDidAppear(_ animated: Bool) {
        if (favoriteDatasets?.count)! > 0 {
            animateTableView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func checkViewVisibility() {
        guard let itemsCount = favoriteDatasets?.count else {
            return
        }
        if itemsCount > 0 {
            favoriteTableView.isHidden = false
            emptyFavoriteView.isHidden = true
        } else {
            favoriteTableView.isHidden = true
            emptyFavoriteView.isHidden = false
        }
    }
    
    private func animateTableView() {
        let table = favoriteTableView.visibleCells
        
        let fromAnimation = AnimationType.from(direction: .right, offset: 170.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        UIView.animate(views: table,
                       animations: [fromAnimation, zoomAnimation], duration: 0.7)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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
            
            SnackbarManager.showMessageSnackbar(text: "ルーレットにデータが反映されました👍")
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let dataset = favoriteDatasets else {
                return
            }
            RealmManager.sharedInstance.deleteFavoriteDataset(object: dataset[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkViewVisibility()
        }
    }
}
