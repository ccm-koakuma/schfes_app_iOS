//
//  NewsVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アイコンを追加し、アイコンを押したときに"TapMenu()"が実行されるように指定
        let menu: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style:UIBarButtonItemStyle.plain, target:self, action:#selector(self.TapMenu))
        // ナビゲーションバーにアイコンを追加
        self.navigationItem.rightBarButtonItem = menu
        
        self.title = "News"
        
        // TableViewを作成
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        
        
        
//        let toStall = UITapGestureRecognizer(target: self, action: #selector(self.toStall))
//        tableView.addGestureRecognizer(toStall)
        
        // データを取得
        let listUrl = "http://qiita-stock.info/api.json";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                print(data)
                self.items.append(data)
            }
            tableView.reloadData()
        }
    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(items[indexPath.row])")
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row]["send_date"].stringValue)"
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func TapMenu() {
        print("メニューがタップされました")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
