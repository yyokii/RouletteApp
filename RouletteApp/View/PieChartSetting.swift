//
//  PieChartView.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/31.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import Charts

class PieChartSetting: UIView {
    
    /// 円グラフの設定処理
    ///
    /// - Parameter chartView: チャートビュー
    static func setPirchartView(chartView: PieChartView) {
        chartView.setExtraOffsets(left: 5, top: 0, right: 5, bottom: 0)
        chartView.legend.enabled = false
        chartView.drawCenterTextEnabled = true
        chartView.drawHoleEnabled = true
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.rotationAngle = 0
        chartView.chartDescription?.text = ""
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.lineBreakMode = .byTruncatingTail
        paragraphStyle?.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "")
        chartView.centerAttributedText = centerText
    }
    
    /// 円グラフのデータ設定処理
    ///
    /// - Parameters:
    ///   - count: データ数
    ///   - range: データレンジ
    static func setDataCount(chartView: PieChartView, _ count: Int, range: UInt32, parties: [String]) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(arc4random_uniform(range) + range / 5),
                                     label: parties[i % parties.count],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        data.setDrawValues(false)
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(UIColor.darkGray)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
}
