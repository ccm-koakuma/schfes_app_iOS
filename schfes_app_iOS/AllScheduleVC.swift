//
//  AllScheduleVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/09/23.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AllScheduleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var checkListItem: [String : Bool] = [:]
    
    let favoIcon = UIImage(named: "images/favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    let noFavoIcon = UIImage(named: "images/no_favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    
    
    
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
        
//        let favo = UITapGestureRecognizer(target: self, action: #selector(self.Favo))
//        tableView.addGestureRecognizer(favo)
        
        // データを取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/timetable";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                self.items.append(data)
                self.checkListItem[data["id"].string!] = false
                print(self.checkListItem)
            }
            tableView.reloadData()
        }
    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(items[indexPath.row])")
        if let cell = tableView.cellForRow(at: indexPath) {
            if self.checkListItem[items[indexPath.row]["id"].string!] == true {
                self.checkListItem[items[indexPath.row]["id"].string!] = false
                cell.imageView?.image = noFavoIcon
            } else {
                self.checkListItem[items[indexPath.row]["id"].string!] = true
                cell.imageView?.image = favoIcon
            }
            cell.isSelected = false
        }
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "開催時刻 : \(items[indexPath.row]["time"].stringValue)"
        
        if self.checkListItem[items[indexPath.row]["id"].string!] == true {
            cell.imageView?.image = favoIcon
        } else {
            cell.imageView?.image = noFavoIcon
        }
        //        cell.textLabel?.text = items["timetable"][indexPath.row]["title"].string
        //        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row].stringValue)"
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
//    func Favo(){
//        print("AllScheduleVC")
//    }
    
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
