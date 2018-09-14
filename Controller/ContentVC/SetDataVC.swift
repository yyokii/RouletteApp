//
//  SetDataVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu
import ChromaColorPicker
import RealmSwift

class SetDataVC: UIViewController, BaseVC {
    @IBOutlet weak var setDataTableView: UITableView!
    @IBOutlet weak var favoriteLabel: FavoriteLabel!
    
    var menuController: CariocaController?
    let colorPickerViewTag = 101
    var rouletteDataset: RouletteDataset?
    var isFavorite = false
    var tappedColorViewCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataTableView.delegate = self
        setDataTableView.dataSource = self
        setDataTableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "RouletteItemCell")
        setFavoriteBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataset = RealmManager.sharedInstance.getRouletteDataset() {
            //rouletteDataset = RouletteDataset(value: dataset[0])

            rouletteDataset = RouletteDataset()
            // コピーオブジェクトを作成
            let copyTitle = dataset[0].titile
            rouletteDataset?.titile = copyTitle

            let copyItems = List<RouletteItemObj>()
            for item in dataset[0].items {
                copyItems.append(RouletteItemObj(value: item))

            }
            rouletteDataset?.items = copyItems
        } else {
            rouletteDataset = RouletteDataset()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setFavoriteBtn() {
        let favoriteLblTap = UITapGestureRecognizer(target: self, action: #selector(favoriteLblTapped(sender:)))
        favoriteLabel.isUserInteractionEnabled = true
        favoriteLabel.addGestureRecognizer(favoriteLblTap)
    }
    
    @objc func favoriteLblTapped (sender: UITapGestureRecognizer) {
        isFavorite = !isFavorite
        if isFavorite {
            favoriteLabel.favorite()
        } else {
            favoriteLabel.notFavorite()
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let rouletteItemObj = RouletteItemObj()
        rouletteDataset?.items.append(rouletteItemObj)
        setDataTableView.reloadData()
    }
    
    @IBAction func setBtnTapped(_ sender: Any) {
        // セットボタンを押下したときだけデータセットを更新する、RouletteDatasetをrealmに保存
        // favorite の状態みて favorite の方にも保存, favしたらRouletteDatasetの方は削除
        
        let center = NotificationCenter.default
        center.post(name: .removeTextFieldFocus, object: nil)
        
        if let dataset = rouletteDataset {
            RealmManager.sharedInstance.addRouletteDataset(object: dataset)
            if isFavorite {
                // お気に入りに追加
                let favoriteDataset = FavoriteDataset()
                favoriteDataset.titile = dataset.titile
                favoriteDataset.items = dataset.items
                RealmManager.sharedInstance.addFavoriteDataset(object: favoriteDataset)
            }
        }
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        // データセットの情報をリセットする、realm内のデータは消さない、空の状態でokを押したらrealm内のデータが変わる
        rouletteDataset = RouletteDataset()
        setDataTableView.reloadData()
    }
}


// MARK: - テーブルビュー
extension SetDataVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let itemsCount = rouletteDataset?.items.count {
            return itemsCount
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteItemCell", for: indexPath) as? RouletteItemCell
        
        cell?.rouletteItemCellDelegate = self
        cell?.configureCell(row: indexPath.row, rouletteItemObj: (rouletteDataset?.items[indexPath.row])!)
        cell?.selectionStyle = .none
        return cell!
    }
}


// MARK: - ルーレットアイテムセル
extension SetDataVC: RouletteItemCellDelegate {
    func itemTextFieldDidEndEditing(row: Int, text: String?) {
        if let itemName = text {
            rouletteDataset?.items[row].itemName = itemName
        }
    }
    
    func ratioTextFieldDidEndEditing(row: Int, text: String?) {
        if let ratioText = text {
            rouletteDataset?.items[row].ratio = Double(ratioText)!
        }
    }
    
    func colorViewTapped(row: Int, colorHex: String) {
        // 選択されたセルが何番目かを保持（rouletteDatasetのデータ更新で使用）
        tappedColorViewCellRow = row
        // 曇りガラスviewを生成
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = EffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.tag = colorPickerViewTag
        self.view.addSubview(blurView)
        // 色選択viewを生成
        let colorPickerView = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPickerView.delegate = self
        colorPickerView.padding = 5
        colorPickerView.stroke = 3
        colorPickerView.adjustToColor(UIColor(hex: (rouletteDataset?.items[row].colorHex)!))
        
        colorPickerView.center = blurView.center
        blurView.contentView.addSubview(colorPickerView)
    }
}

// MARK: - 色が選択されたらデータセットオブジェクトの値を更新する
extension SetDataVC: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        rouletteDataset?.items[tappedColorViewCellRow!].colorHex = color.hexCode
        
        let fetchedColorPickerView = self.view.viewWithTag(colorPickerViewTag)
        fetchedColorPickerView?.removeFromSuperview()
        setDataTableView.reloadData()
    }
}
