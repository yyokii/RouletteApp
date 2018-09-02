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

class SetDataVC: UIViewController, BaseVC {
    @IBOutlet weak var setDataTableView: UITableView!
    
    var menuController: CariocaController?
    let colorPickerViewTag = 1
    var rouletteDataset: RouletteDataset?
    var tappedColorViewCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataTableView.delegate = self
        setDataTableView.dataSource = self
        setDataTableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "RouletteItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rouletteDataset = RouletteDataset.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let rouletteItemObj = RouletteItemObj(colorHex: "FF9300", itemName: "アイテム", ratio: 1)
        rouletteDataset?.items.append(rouletteItemObj)
        setDataTableView.reloadData()
    }
    
    @IBAction func setBtnTapped(_ sender: Any) {
        // セットボタンを押下したときだけデータセットを更新する
    }
}

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("選択されたcell：\(indexPath.row)")
    }
}

extension SetDataVC: RouletteItemCellDelegate {
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

extension SetDataVC: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        let fetchedColorPickerView = self.view.viewWithTag(colorPickerViewTag)
        fetchedColorPickerView?.removeFromSuperview()
        
        rouletteDataset?.items[tappedColorViewCellRow!].colorHex = color.hexCode
        setDataTableView.reloadData()
    }
}
