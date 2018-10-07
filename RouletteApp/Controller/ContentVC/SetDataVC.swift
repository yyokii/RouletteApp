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
import ViewAnimator

class SetDataVC: UIViewController, BaseVC {
    @IBOutlet weak var emptyDatasetView: EmptyDatasetView!
    @IBOutlet weak var setDataTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var favoriteLabel: FavoriteLabel!
    @IBOutlet weak var addBtn: UIButton!
    
    let center = NotificationCenter.default
    let colorPickerViewTag = 101
    var isFavorite = false
    var menuController: CariocaController?
    // 編集可能な、表示用のオブジェクト（unmanaged）
    var rouletteDataset: RouletteDataset?
    var tappedColorViewCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotificationObserver()
        
        titleTextField.tag = 1
        titleTextField.delegate = self
        setDataTableView.delegate = self
        setDataTableView.dataSource = self
        setDataTableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "RouletteItemCell")
        setFavoriteBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataset = RealmManager.sharedInstance.setDataset {
            rouletteDataset = RealmManager.sharedInstance.copyOfRouletteDataset(dataset: dataset)
        } else {
            rouletteDataset = RouletteDataset()
        }
        checkViewVisibility()
        titleTextField.text = rouletteDataset?.titile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (rouletteDataset?.items.count)! > 0 {
            animateTableView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setNotificationObserver() {
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    private func checkViewVisibility() {
        guard let itemsCount = rouletteDataset?.items.count else {
            return
        }
        if itemsCount > 0 {
            setDataTableView.isHidden = false
            emptyDatasetView.isHidden = true
            
        } else {
            setDataTableView.isHidden = true
            emptyDatasetView.isHidden = false
        }
    }
    
    private func animateTableView() {
        let table = setDataTableView.visibleCells
        
        let fromAnimation = AnimationType.from(direction: .right, offset: 170.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        UIView.animate(views: table,
                       animations: [fromAnimation, zoomAnimation], duration: 0.7)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            setDataTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            setDataTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if (rouletteDataset?.items.count)! < 1 {
            // １つ目を追加したらテーブルを表示させる
            setDataTableView.isHidden = false
            emptyDatasetView.isHidden = true
        }
        let rouletteItemObj = RouletteItemObj()
        let colorIndex = ((rouletteDataset?.items.count)!) % 15
        rouletteItemObj.colorHex = rouletteDefaultColors[colorIndex]
        rouletteDataset?.items.append(rouletteItemObj)
        
        let index = IndexPath(row: (rouletteDataset?.items.count)! - 1, section: 0)
        setDataTableView.insertRows(at: [index], with: UITableViewRowAnimation.left)
    }
    
    @IBAction func setBtnTapped(_ sender: Any) {
        // セットボタンを押下したときだけデータセットを更新する
        // favorite の状態みて favorite の方にも保存, favしたらRouletteDatasetの方は削除
        
        titleTextField.endEditing(true)
        center.post(name: .removeTextFieldFocus, object: nil)
        
        if let dataset = rouletteDataset {
            RealmManager.sharedInstance.updateSetDataset(dataset: dataset)
            if isFavorite {
                // お気に入りに追加
                let copyEditableDataset = RealmManager.sharedInstance.copyOfRouletteDataset(dataset: dataset)
                
                let favoriteDataset = RouletteDataset()
                favoriteDataset.titile = copyEditableDataset.titile
                favoriteDataset.items = copyEditableDataset.items
                
                RealmManager.sharedInstance.addRouletteDataset(object: favoriteDataset)
                SnackbarManager.showMessageSnackbar(text: "データを設定しました👍\nお気に入りに登録しました❤️")
            } else {
                SnackbarManager.showMessageSnackbar(text: "データを設定しました👍")
            }
        }
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        guard (rouletteDataset?.items.count)! > 0 else {
            return
        }
        // リセット処理が完了するまでは「追加」処理ができないようにする（データ不整合が生じるのを防ぐため）
        addBtn.isEnabled = false
        
        // データセットの情報をリセットする、realm内のデータは消さない、空の状態でokを押したらrealm内のデータが変わる
        rouletteDataset = RouletteDataset()
        UIView.animate(views: setDataTableView.visibleCells, animations: [AnimationType.from(direction: .bottom, offset: 30.0)], reversed: true,
                       initialAlpha: 1.0, finalAlpha: 0.0, completion: {
                        self.setDataTableView.reloadData()
                        self.checkViewVisibility()
                        self.addBtn.isEnabled = true
        })
    }
}

// MARK: - タイトルテキストフィールド
extension SetDataVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
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
            checkViewVisibility()
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
            rouletteDataset?.items[row].ratio = Int(ratioText)!
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

        // 色選択viewを生成
        let colorPickerView = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPickerView.delegate = self
        colorPickerView.padding = 5
        colorPickerView.stroke = 3
        colorPickerView.adjustToColor(UIColor(hex: (rouletteDataset?.items[row].colorHex)!))
        colorPickerView.center = blurView.center
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(blurView)
            blurView.contentView.addSubview(colorPickerView)
        }, completion: nil)
    }
}

// MARK: - 色が選択されたらデータセットオブジェクトの値を更新する
extension SetDataVC: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        rouletteDataset?.items[tappedColorViewCellRow!].colorHex = color.hexCode
        
        let fetchedColorPickerView = self.view.viewWithTag(colorPickerViewTag)
        UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            fetchedColorPickerView?.removeFromSuperview()
        }, completion: nil)
        
        setDataTableView.reloadData()
    }
}
