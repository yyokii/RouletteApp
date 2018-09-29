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

class PieChartManager: UIView {
    
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
        //chartView.rotationAngle = 0
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
    ///   - chartView: チャートビュー
    ///   - rouletteDataset: データ内容
    static func setDataCount(chartView: PieChartView, rouletteDataset: RouletteDataset?) {
        guard let dataset = rouletteDataset else {
            return
        }
        
        // データを設定
        let range = getRange(rouletteItemObjList: dataset.items)
        let entries = (0..<dataset.items.count).map { (num) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: (Double(dataset.items[num].ratio)/Double(range)) * 100,
                                     label: dataset.items[num].itemName,
                                     icon: nil)
        }
                
        let set = PieChartDataSet(values: entries, label: "Roulette")
        
        // 色を設定
        set.colors = (0..<dataset.items.count).map { (num) -> UIColor in
            return UIColor(hex: dataset.items[num].colorHex)
        }
        
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        
        let data = PieChartData(dataSet: set)
        data.setDrawValues(false)
        data.setValueFont(.systemFont(ofSize: 20, weight: .bold))
        data.setValueTextColor(UIColor.darkGray)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    /// データを円グラフで「%」表示にしたいので、割合計算時の分母を作る用
    ///
    /// - Parameter rouletteItemObjList: dbから取得した投稿データ
    /// - Returns: 分母として使う数字
    static func getRange(rouletteItemObjList: List<RouletteItemObj>) -> Int {
        var countSum = 0
        for data in rouletteItemObjList {
            countSum += Int(data.ratio)
        }
        return countSum
    }
    
    /// ルーレットの結果選択されたアイテムを取得する
    ///
    /// - Parameters:
    ///   - chartView: パイチャートビュー
    ///   - rouletteDataset: ルーレットのデータ
    ///   - angle: 回転した角度
    /// - Returns: 選択されたアイテムデータ
    static func getSelectedData(chartView: PieChartView, rouletteDataset: RouletteDataset?, angle: Double) -> RouletteItemObj? {
        guard let dataset = rouletteDataset else {
            return nil
        }
        let ratioArray = (0..<dataset.items.count).map { (num) -> Double in
            return Double(dataset.items[num].ratio)/Double(getRange(rouletteItemObjList: dataset.items))
        }
        let angleRatio = angle/360.0
        
        var sum = 0.0
        // カウントをインデックスに変換するために-1
        var indexCounter = dataset.items.count - 1
        
        for index in (0..<ratioArray.count).reversed() {
            sum += ratioArray[index]
            if angleRatio <= Double(sum) {
                break
            }
            indexCounter -= 1
        }
        return dataset.items[indexCounter]
    }
}
