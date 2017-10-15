//
//  SettingMenu.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/15.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

class SettingMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Tableで使用する配列を設定する
    private let settingItems: NSArray = ["設定", "通知機能", "アプリの使い方", "CCMとは？"]
    private var settingTableView: UITableView!
    
    // オレンジカラー作成
    let orangeColor = UIColor(red: 235/255.0, green: 97/255.0, blue: 0/255.0, alpha: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = SlideVC.menuWidth
        let displayHeight: CGFloat = self.view.frame.height
    
        // TableViewの生成(Status barの高さをずらして表示).
        settingTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        
        // Cell名の登録をおこなう.
        settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        // DataSourceを自身に設定する.
        settingTableView.dataSource = self
        // Delegateを自身に設定する.
        settingTableView.delegate = self
        // 下部の何も無いセルを表示しない
        settingTableView.tableFooterView = UIView(frame: .zero)
        // スクロールを禁止する
        settingTableView.isScrollEnabled = false
        
        // Viewに追加する.
        self.view.addSubview(settingTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(settingItems[indexPath.row])")
        if let cell = tableView.cellForRow(at: indexPath) {
            // cellの選択を解除する
            // これがないとセルを選択した時グレーになり続ける
            cell.isSelected = false
        }
    }
    
    /*
     Cellの総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    /*
     Cellに値を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(settingItems[indexPath.row])"
        
        if indexPath.row == 0 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
//            cell.textLabel?.sizeToFit()
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = orangeColor
        }

        
        return cell
    }

    // セルの高さの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 65
        } else {
            return 50
        }
    }
}
