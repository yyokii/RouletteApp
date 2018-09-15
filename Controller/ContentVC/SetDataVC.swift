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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var favoriteLabel: FavoriteLabel!
    
    let center = NotificationCenter.default
    let colorPickerViewTag = 101
    var isFavorite = false
    var menuController: CariocaController?
    // 編集可能な、表示用のオブジェクトとして扱う。Realmから取得する場合はcopyしたものを格納する。編集後のものをRealmに保存する場合にはmanagedオブジェクトにならないように（編集オブジェクトとして扱い続けるために）copyオブジェクトを作成しRealmに保存するようにする。
    var rouletteDataset: RouletteDataset?
    var tappedColorViewCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.tag = 1
        setDataTableView.delegate = self
        setDataTableView.dataSource = self
        setDataTableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "RouletteItemCell")
        setFavoriteBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataset = RealmManager.sharedInstance.getRouletteDataset() {
            rouletteDataset = RealmManager.sharedInstance.copyOfRouletteDataset(dataset: dataset[0])
        } else {
            rouletteDataset = RouletteDataset()
        }
        
        titleTextField.text = rouletteDataset?.titile
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
        
        titleTextField.endEditing(true)
        center.post(name: .removeTextFieldFocus, object: nil)
        
        if let dataset = rouletteDataset {
            let copyEditableDataset = RealmManager.sharedInstance.copyOfRouletteDataset(dataset: dataset)
            
            RealmManager.sharedInstance.addRouletteDataset(object: copyEditableDataset)
            if isFavorite {
                // お気に入りに追加 FIXMEな気がする
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

extension SetDataVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            // タイトルテキストフィールド
            if let title = titleTextField.text {
                rouletteDataset?.titile = title
            } else {
                rouletteDataset?.titile = "no name"
            }
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rouletteDataset?.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
