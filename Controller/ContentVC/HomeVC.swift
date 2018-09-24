//
//  HomeVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/29.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu
import Charts
import ViewAnimator

class HomeVC: UIViewController, BaseVC, ChartViewDelegate {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emptyRouletteView: EmptyRouletteView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var rouletteBtn: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    weak var menuController: CariocaController?
    var rouletteDataset: RouletteDataset?
    // true: 回転中、　false：停止中
    var spinFlag = false
    var selectedItem: RouletteItemObj?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        spinFlag = false
        pieChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataset = RealmManager.sharedInstance.setDataset {
            rouletteDataset = dataset
        } else {
            rouletteDataset = RouletteDataset()
        }
        
        if (rouletteDataset?.items.count)! < 1 {
            rouletteDataset?.titile = "ようこそ👋"
        }
        resultLbl.text = "Result: なし"
        checkViewVisibility()
        applyPieChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateView()
    }
    
    private func applyPieChartData() {
        titleLbl.text = rouletteDataset?.titile
        PieChartManager.setPieChartView(chartView: pieChartView)
        PieChartManager.setDataCount(chartView: pieChartView, rouletteDataset: rouletteDataset)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func checkViewVisibility() {
        guard let itemsCount = rouletteDataset?.items.count else {
            return
        }
        if itemsCount > 0 {
            arrowImageView.isHidden = false
            pieChartView.isHidden = false
            emptyRouletteView.isHidden = true
        } else {
            arrowImageView.isHidden = true
            pieChartView.isHidden = true
            emptyRouletteView.isHidden = false
        }
    }
    
    private func animateView() {
        let fromAnimation = AnimationType.from(direction: .top, offset: 100.0)
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        
        titleLbl.animate(animations: [fromAnimation, zoomAnimation], duration: 0.5)
        arrowImageView.animate(animations: [fromAnimation, zoomAnimation], duration: 0.5)
    }
    
    @IBAction func rouletteBtn(_ sender: Any) {
        guard (rouletteDataset?.items.count)! > 0 else {
            return
        }
        
        if spinFlag {
            // 回転中（durationが0では動かない（spinしない）、デフォルトのangle値は270なのでそこから動かす）
            
            let resultAngle = arc4random_uniform(360 + 1)
            pieChartView.spin(duration: 0.01,
                           fromAngle: 270,
                           toAngle: CGFloat(270 + resultAngle),
                           easingOption: .easeOutBack)
            rouletteBtn.backgroundColor = UIColor(hex: "005493")
            rouletteBtn.setTitle("  START🏁  ", for: UIControlState.normal)
            
            selectedItem = PieChartManager.getSelectedData(chartView: pieChartView, rouletteDataset: rouletteDataset, angle: 200)
            guard let item = selectedItem else {
                return
            }
            
            // 結果をviewでフィードバックする
            resultLbl.text = "Result: \(item.itemName)🎉"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                PopupDialogManager.showOneBtnDialog(vc: self, title: "「\(item.itemName)」🎉\nが選ばれました！", message: "", btnTitle: "OK👍", btnTapped: {}, completion: nil)
            }
            
        } else {
            // 停止中
            pieChartView.spin(duration: 20,
                              fromAngle: pieChartView.rotationAngle,
                              toAngle: pieChartView.rotationAngle + 10000,
                              easingOption: .easeOutBack)
            rouletteBtn.backgroundColor = UIColor(hex: "E91E63")
            rouletteBtn.setTitle("  STOP⏹  ", for: UIControlState.normal)
        }
        spinFlag = !spinFlag
    }
}
