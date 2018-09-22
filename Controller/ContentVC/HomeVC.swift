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

class HomeVC: UIViewController, BaseVC, ChartViewDelegate {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emptyRouletteView: EmptyRouletteView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var rouletteBtn: UIButton!
    
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
            // FIXME: リスト内が0の時もあるので修正必要かも
            rouletteDataset?.titile = "🎰 ルーレット 🎲"
        }
        resultLbl.text = "Result: なし"
        checkViewVisibility()
        applyPieChartData()
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
            pieChartView.isHidden = false
            emptyRouletteView.isHidden = true
        } else {
            pieChartView.isHidden = true
            emptyRouletteView.isHidden = false
        }
    }
    
    @IBAction func rouletteBtn(_ sender: Any) {
        if spinFlag {
            // 回転中（durationが0では動かない（spinしない）、デフォルトのangle値は270なのでそこから動かす）
            pieChartView.spin(duration: 0.01,
                           fromAngle: 270,
                           toAngle: 270 + 200,
                           easingOption: .easeOutBack)
            // FIXME: テキスト変更うまくいってない、フラグのgetter,setterで設定した方がいいかも
            rouletteBtn.titleLabel?.text = "スタート"
            
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
           rouletteBtn.titleLabel?.text = "ストップ"
        }
        spinFlag = !spinFlag
    }
}
