//
//  EtCeteraVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/22.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import CariocaMenu
import PopupDialog

class EtCeteraVC: UIViewController, BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuController: CariocaController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EtCetraItemCell", bundle: nil), forCellReuseIdentifier: "EtCetraItemCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EtCeteraVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EtCetraItemCell", for: indexPath) as? EtCetraItemCell
        
        switch indexPath.row {
        case 0:
            cell?.configureCell(text: "使い方")
        case 1:
            cell?.configureCell(text: "開発した人　：　@enyyokii")
        case 2:
            cell?.configureCell(text: "このアプリをシェアする")
        case 3:
            cell?.configureCell(text: "レビューする")
        default:
            cell?.configureCell(text: "")
        }
        cell?.selectionStyle = .none
        return cell!
    }
}

extension EtCeteraVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            PopupDialogManager.showOneBtnDialog(vc: self,
                                                title: "①右にあるメニューから「データセット」を選択し、ルーレットのデータを設定しましょう！\n\n②「OK」を押すと、ルーレットに反映されます！\n\n③「データセット」で「❤️」をタップしてから「OK」を押すと、お気に入りに追加することもできます！",
                                                message: "",
                                                btnTitle: "OK👍",
                                                btnTapped: {},
                                                completion: nil)
        case 1:
            let url = URL(string: "https://twitter.com/enyyokii")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case 2:
            print("2")
        case 3:
            print("3")
        default:
            print("4")
        }
    }
}
