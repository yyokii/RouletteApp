//
//  BaseVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/29.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu

protocol BaseVC: class {
    func add(in parentViewController: UIViewController)
    func remove()
    var menuController: CariocaController? { get set }
}

extension BaseVC where Self: UIViewController {
    
    func add(in parentViewController: UIViewController) {
        parentViewController.addChildViewController(self)
        self.view.backgroundColor = .clear
        parentViewController.view.addSubview(self.view)
        parentViewController.view.addConstraints(self.view.makeAnchorConstraints(to: parentViewController.view))
        parentViewController.view.layoutIfNeeded()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// Removes the current view controller from the parent view controller
    func remove() {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}
