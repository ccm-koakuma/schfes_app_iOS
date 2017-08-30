//
//  ViewController.swift
//  schfes_app_iOS
//
//  Created by 藤尾和裕 on 2017/06/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewを作成
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let toStall = UITapGestureRecognizer(target: self, action: #selector(ViewController.toStall))
        tableView.addGestureRecognizer(toStall)
        
        // QiitaのAPIからデータを取得
//        let listUrl = "http://qiita-stock.info/api.json";
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/timetable";
//        let listUrl = "http://133.55.75.10/timetable.json";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                print(data)
                self.items.append(data)

            }
            tableView.reloadData()        }
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
        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row]["time"].stringValue)"
//        cell.textLabel?.text = items["timetable"][indexPath.row]["title"].string
//        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row].stringValue)"
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func toStall(){
        self.performSegue(withIdentifier: "toStall", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "toStall" {
//            let stallVC = segue.destination as! StallVC
//            stallVC.items = sender as! [JSON]
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
