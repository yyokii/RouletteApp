//
//  ViewController.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/28.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu

class ViewController: UIViewController {
    var carioca: CariocaMenu?
    weak var menuController: CariocaController?
    weak var demoView: BaseVC?
    
    override func viewDidLoad() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialiseCarioca()
    }
    
    func initialiseCarioca() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
            as? CariocaController {
            addChildViewController(controller)
            carioca = CariocaMenu(controller: controller,
                                  hostView: self.view,
                                  edges: [.right, .left], //[.left, .right], //[.left],
                delegate: self,
                indicator: CariocaCustomIndicatorView() //CustomPolygonIndicator()
            )
            carioca?.addInHostView()
            menuController = controller
            displayView(HomeVC.fromStoryboard())
        }
    }
    
    // MARK: Rotation management
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: self.view, animation: nil, completion: { [weak self] _ in
            self?.carioca?.hostViewDidRotate()
        })
    }
    
    func displayView(_ controller: BaseVC) {
        if let existingDemo = demoView {
            existingDemo.remove()
            demoView = nil
        }
        demoView = controller
        demoView?.menuController = menuController!
        demoView?.add(in: self)
        carioca?.bringToFront()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let demoController = demoView as? UIViewController else {
            return UIStatusBarStyle.lightContent
        }
        return demoController.preferredStatusBarStyle
    }
}

extension ViewController: CariocaDelegate {
    func cariocamenu(_ menu: CariocaMenu, didSelect item: CariocaMenuItem, at index: Int) {
        switch index {
        case 0:
            displayView(HomeVC.fromStoryboard())
        case 1:
            displayView(SetDataVC.fromStoryboard())
        case 2:
            displayView(FavoriteVC.fromStoryboard())
        case 3:
            print("didSelect：4")
            //displayDemo(DemoIdeaViewController.fromStoryboard())
        default:
            displayView(HomeVC.fromStoryboard())
        }
    }
    
    func cariocamenu(_ menu: CariocaMenu, willOpenFromEdge edge: UIRectEdge) {
        CariocaMenu.log("will open from \(edge)")
    }
}

class CariocaCustomIndicatorView: UIView, CariocaIndicatorConfiguration {
    var color: UIColor = UIColor(hex: menuIndicator)
}
