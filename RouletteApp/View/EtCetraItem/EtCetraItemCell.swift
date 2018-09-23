//
//  EtCetraItemCell.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/23.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class EtCetraItemCell: UITableViewCell {
    @IBOutlet weak var itemLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(text: String) {
        itemLbl.text = text
    }
}
