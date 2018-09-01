//
//  SetDataVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu

class SetDataVC: UIViewController, BaseVC {
    @IBOutlet weak var setDataTableView: UITableView!
    
    var menuController: CariocaController?
    let colorPickerViewTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataTableView.delegate = self
        setDataTableView.dataSource = self
        setDataTableView.register(UINib(nibName: "RouletteItemCell", bundle: nil), forCellReuseIdentifier: "RouletteItemCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SetDataVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteItemCell", for: indexPath) as? RouletteItemCell
        cell?.rouletteItemCellDelegate = self
        cell?.selectionStyle = .none
        return (cell)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SetDataVC: RouletteItemCellDelegate {
    func colorViewTapped(colorPickerView: UIControl) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = EffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.tag = colorPickerViewTag
        self.view.addSubview(blurView)
        
        colorPickerView.center = blurView.center
        blurView.contentView.addSubview(colorPickerView)
    }
    
    func colorChoosed() {
        // カラーピッカーの削除
        let fetchedColorPickerView = self.view.viewWithTag(colorPickerViewTag)
        fetchedColorPickerView?.removeFromSuperview()
    }
}
