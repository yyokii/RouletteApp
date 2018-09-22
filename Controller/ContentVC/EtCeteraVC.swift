//
//  EtCeteraVC.swift
//  RouletteApp
//
//  Created by Yoki Higashihara on 2018/09/22.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class EtCeteraVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EtCeteraVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteItemCell", for: indexPath) as? RouletteItemCell
//
//        cell?.rouletteItemCellDelegate = self
//        cell?.configureCell(row: indexPath.row, rouletteItemObj: (rouletteDataset?.items[indexPath.row])!)
//        cell?.selectionStyle = .none
        return UITableViewCell()
    }
}
