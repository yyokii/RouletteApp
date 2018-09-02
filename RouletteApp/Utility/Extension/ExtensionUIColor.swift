//
//  ExtensionUIColor.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/01.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let values = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let red = CGFloat(Int(values[0] + values[1], radix: 16) ?? 0) / 255.0
        let green = CGFloat(Int(values[2] + values[3], radix: 16) ?? 0) / 255.0
        let blue = CGFloat(Int(values[4] + values[5], radix: 16) ?? 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
