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
    var resultAngle: UInt32 = 0
    
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
            rouletteDataset?.titile = "ルーレット"
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
            pieChartView.spin(duration: 0.01,
                           fromAngle: 270,
                           toAngle: CGFloat(270 + resultAngle),
                           easingOption: .linear)
            rouletteBtn.backgroundColor = UIColor(hex: "005493")
            rouletteBtn.setTitle("  START🏁  ", for: UIControlState.normal)
            
            selectedItem = PieChartManager.getSelectedData(chartView: pieChartView, rouletteDataset: rouletteDataset, angle: Double(resultAngle))
            guard let item = selectedItem else {
                return
            }
            
            // 結果をviewでフィードバックする
            resultLbl.text = "Result: \(item.itemName)🎉"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                PopupDialogManager.showOneBtnDialog(vc: self, title: "「\(item.itemName)」🎉\nが選ばれました！", message: "", btnTitle: "OK👍", btnTapped: {}, completion: nil)
            }
            
        } else {
            resultLbl.text = "Result: なし"
            resultAngle = arc4random_uniform(360 + 1)
            // 停止中
            pieChartView.spin(duration: 10,
                              fromAngle: 270,
                              toAngle: 270 + 10080 + CGFloat(resultAngle),
                              easingOption: .linear)
            rouletteBtn.backgroundColor = UIColor(hex: "E91E63")
            rouletteBtn.setTitle("  STOP⏹  ", for: UIControlState.normal)
        }
        spinFlag = !spinFlag
    }
}
