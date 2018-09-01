//
//  RouletteItemCell.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class RouletteItemCell: UITableViewCell {

    @IBOutlet weak var colorView: CircleView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var ratioTextField: UITextField!
    
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
    }
}
