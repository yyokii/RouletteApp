//
//  FavoriteItemCell.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/03.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class FavoriteItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
