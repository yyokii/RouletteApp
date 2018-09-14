//
//  PieChartView.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/08/31.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class PieChartSetting: UIView {
    
    /// 円グラフの設定処理
    ///
    /// - Parameter chartView: チャートビュー
    static func setPieChartView(chartView: PieChartView) {
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
    static func setDataCount(chartView: PieChartView, rouletteDataset: RouletteDataset?) {
        guard let dataset = rouletteDataset else {
            return
        }
        
        // データを設定
        let range = getRange(rouletteItemObjList: dataset.items)
        let entries = (0..<dataset.items.count).map { (num) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(dataset.items[num].ratio)/range * 100.0,
                                     label: dataset.items[num].itemName,
                                     icon: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "Roulette")

        // 色を設定
        set.colors = (0..<dataset.items.count).map { (num) -> UIColor in
            return UIColor(hex: dataset.items[num].colorHex)
        }
        
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        let data = PieChartData(dataSet: set)
        
        data.setDrawValues(false)
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(UIColor.darkGray)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    /// データを円グラフで「%」表示にしたいので、割合計算時の分母を作る用
    ///
    /// - Parameter rouletteItemObjList: dbから取得した投稿データ
    /// - Returns: 分母として使う数字
    static func getRange(rouletteItemObjList: List<RouletteItemObj>) -> Double {
        var countSum = 0.0
        for data in rouletteItemObjList {
            countSum += Double(data.ratio)
        }
        return countSum
    }
}
