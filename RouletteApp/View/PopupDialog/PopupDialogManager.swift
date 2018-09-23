//
//  PopupDialogManager.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/15.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import PopupDialog

class PopupDialogManager {
    
    // swiftlint:disable:next function_parameter_count
    static func showOneBtnDialog(vc: UIViewController, title: String, message: String, btnTitle: String, btnTapped: @escaping () -> Void, completion: (() -> Void)?, animated: Bool = true) {
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: false) {
                                    print("Completed")
        }
        let btn = DefaultButton(title: btnTitle) {
            btnTapped()
        }
        popup.addButtons([btn])
        vc.present(popup, animated: animated, completion: completion)
    }
    
    // swiftlint:disable:next function_parameter_count
    static func showOkCancelDialog(vc: UIViewController, title: String, message: String, cancelTapped: @escaping () -> Void, okTapped: @escaping () -> Void, completion: (() -> Void)?, animated: Bool = true) {
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: false) {
                                    print("Completed")
        }
        let cancelBtn = CancelButton(title: "CANCEL❎") {
            cancelTapped()
        }
        let okBtn = DefaultButton(title: "OK👍") {
            okTapped()
        }
        popup.addButtons([cancelBtn, okBtn])
        vc.present(popup, animated: animated, completion: completion)
    }
    
    static func showDeveloperDialog(vc: UIViewController, animated: Bool = true) {
        let developerVC = DeveloperVC(nibName: "DeveloperVC", bundle: nil)
        let popup = PopupDialog(viewController: developerVC, buttonAlignment: .horizontal, transitionStyle: .zoomIn, preferredWidth: 340.0, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: false, completion: nil)
        
        let buttonOne = CancelButton(title: "OK👍") {
        }
        
        popup.addButtons([buttonOne])
        vc.present(popup, animated: animated, completion: nil)
    }
}
