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
    func itemTextFieldDidEndEditing(row: Int, text: String?)
    func ratioTextFieldDidEndEditing(row: Int, text: String?)
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
        setupUI()
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(removeTextFieldFocus),
                           name: .removeTextFieldFocus,
                           object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        itemTextField.tag = 1
        ratioTextField.tag = 2
        
        itemTextField.delegate = self
        ratioTextField.delegate = self
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped(sender:)))
        colorView.addGestureRecognizer(imageViewTap)
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
    
    @objc private func removeTextFieldFocus() {
        itemTextField.endEditing(true)
        ratioTextField.endEditing(true)
    }
}

extension RouletteItemCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            rouletteItemCellDelegate?.itemTextFieldDidEndEditing(row: row!, text: textField.text)
        } else if textField.tag == 2 {
            rouletteItemCellDelegate?.ratioTextFieldDidEndEditing(row: row!, text: textField.text)
        }
    }
}
