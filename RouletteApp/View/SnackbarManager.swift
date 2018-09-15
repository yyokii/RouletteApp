//
//  SnackbarManager.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/16.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import MaterialComponents.MaterialSnackbar

class SnackbarManager {
    static func showMessageSnackbar (text: String) {
        let message = MDCSnackbarMessage()
        message.text = text
        MDCSnackbarManager.show(message)
    }
}
