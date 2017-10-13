//
//  StallView.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/28.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    let shopTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの設定
        self.shopTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.shopTableView.delegate = self
        self.shopTableView.dataSource = self
        self.view.addSubview(self.shopTableView)
        
        // データを取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/stall";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                print(data)
                self.items.append(data)
                
            }
            self.shopTableView.reloadData()
        }
    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toShopDetail", sender: nil)
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items[indexPath.row]["slname"].string
        cell.detailTextLabel?.text = items[indexPath.row]["stname"].stringValue
        //        cell.textLabel?.text = items["timetable"][indexPath.row]["title"].string
        //        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row].stringValue)"
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func toStall(){
        self.performSegue(withIdentifier: "toShopDetail", sender: nil)
//        print("hoge")
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    //        if segue.identifier == "toStall" {
    //            let stallVC = segue.destination as! StallVC
    //            stallVC.items = sender as! [JSON]
    //        }
    //    }
    
    // 戻ろボタンで戻ってきた時の処理
    // これをつけることによってどこをタップしてきたのかわかりやすくする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = self.shopTableView.indexPathForSelectedRow {
            self.shopTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
