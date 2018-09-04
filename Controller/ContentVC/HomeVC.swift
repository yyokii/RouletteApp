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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var rouletteBtn: UIButton!
    
    weak var menuController: CariocaController?
    var rouletteDataset: RouletteDataset?
    // true: 回転中、　false：停止中
    var spinFlag = false
    // ルーレットを止める場所
    var angle = 0
    // サンプルデータ
    let parties = ["Party A", "Party B", "Party C", "Party D", "Party E", "Party F",
                   "Party G", "Party H", "Party I", "Party J", "Party K", "Party L",
                   "Party M", "Party N", "Party O", "Party P", "Party Q", "Party R",
                   "Party S", "Party T", "Party U", "Party V", "Party W", "Party X",
                   "Party Y", "Party Z"]
    
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
        applyPieChartView()
    }
    
    private func applyPieChartView() {
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
