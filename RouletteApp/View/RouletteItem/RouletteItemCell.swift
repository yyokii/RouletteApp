//
//  RouletteItemCell.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import ChromaColorPicker

protocol RouletteItemCellDelegate: class {
    func colorViewTapped(colorPickerView: UIControl)
    func colorChoosed()
}

class RouletteItemCell: UITableViewCell {

    @IBOutlet weak var colorView: CircleView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    
    weak var rouletteItemCellDelegate: RouletteItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped(sender:)))
        colorView.addGestureRecognizer(imageViewTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func colorViewTapped(sender: UITapGestureRecognizer) {
        // 色選択viewを表示
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        neatColorPicker.delegate = self //ChromaColorPicker
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.adjustToColor(colorView.backgroundColor!)
        
        rouletteItemCellDelegate?.colorViewTapped(colorPickerView: neatColorPicker)
    }
}

extension RouletteItemCell: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colorView.backgroundColor = color
        rouletteItemCellDelegate?.colorChoosed()
    }
}
