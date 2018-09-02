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
    func colorViewTapped(row: Int, colorHex: String)
}

class RouletteItemCell: UITableViewCell {

    @IBOutlet weak var colorView: CircleView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    
    // 何番目のcellか
    var row: Int?
    var rouletteItemObj: RouletteItemObj?
    
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
    
    func configureCell(row: Int, rouletteItemObj: RouletteItemObj) {
        self.row = row
        self.rouletteItemObj = rouletteItemObj
        colorView.backgroundColor = UIColor.init(hex: rouletteItemObj.colorHex)
        itemTextField.text = rouletteItemObj.itemName
        ratioTextField.text = "\(rouletteItemObj.ratio)"
    }
    
    @objc private func colorViewTapped(sender: UITapGestureRecognizer) {
        rouletteItemCellDelegate?.colorViewTapped(row: row!, colorHex: (rouletteItemObj?.colorHex)!)
    }
}
