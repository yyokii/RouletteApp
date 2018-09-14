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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var rouletteBtn: UIButton!
    
    weak var menuController: CariocaController?
    var rouletteDataset: RouletteDataset?
    // true: 回転中、　false：停止中
    var spinFlag = false
    // ルーレットを止める場所
    var angle = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        spinFlag = false
        pieChartView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let dataset = RealmManager.sharedInstance.getRouletteDataset() {
            rouletteDataset = dataset[0]
        } else {
            rouletteDataset = RouletteDataset()
        }
        applyPieChartData()
    }
    
    private func applyPieChartData() {
        titleLbl.text = rouletteDataset?.titile
        PieChartSetting.setPieChartView(chartView: pieChartView)
        PieChartSetting.setDataCount(chartView: pieChartView, rouletteDataset: rouletteDataset)
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    @IBAction func rouletteBtn(_ sender: Any) {
        if spinFlag {
            // 回転中
            pieChartView.spin(duration: 0,
                           fromAngle: pieChartView.rotationAngle,
                           toAngle: pieChartView.rotationAngle + 0,
                           easingOption: .easeInCubic)
            // FIXME: テキスト変更うまくいってない、フラグのgetter,setterで設定した方がいいかも
            rouletteBtn.titleLabel?.text = "スタート"
        } else {
            // 停止中
            pieChartView.spin(duration: 20,
                              fromAngle: pieChartView.rotationAngle,
                              toAngle: pieChartView.rotationAngle + 360000,
                              easingOption: .easeInCubic)
           rouletteBtn.titleLabel?.text = "ストップ"
        }
        spinFlag = !spinFlag
    }
}
