//
//  Storyboardable.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/29.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation

import Foundation
import UIKit

protocol Storyboardable: class {
    static var defaultStoryboardName: String { get }
}

extension Storyboardable where Self: UIViewController {
    static var defaultStoryboardName: String {
        return "Main"
    }
    
    static func fromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: defaultStoryboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            fatalError("Could not instantiate view controller")
        }
        return viewController
    }
}

extension UIViewController: Storyboardable { }
