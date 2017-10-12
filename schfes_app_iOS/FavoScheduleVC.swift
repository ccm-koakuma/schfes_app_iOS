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

class FavoScheduleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // お気に入り時の画像
    let favoIcon = UIImage(named: "images/favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    // 非お気に入り時の画像
    let noFavoIcon = UIImage(named: "images/no_favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    
    // お気に入り登録しているかどうかの値を保持する変数
    // アプリが落ちても値を保持できるUserDefaultsを使用
    let userDefaults = UserDefaults.standard
    
    // AllScheduleVCからリロードできるようにするため、staticに設定
    static let favoScheduleTableView: UITableView = UITableView()
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの設定
        FavoScheduleVC.favoScheduleTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        FavoScheduleVC.favoScheduleTableView.delegate = self
        FavoScheduleVC.favoScheduleTableView.dataSource = self
        self.view.addSubview(FavoScheduleVC.favoScheduleTableView)
        
        // データを取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/timetable";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                // itemsに取得したデータを追加
                self.items.append(data)
            }
            // テーブルビューのりろー度
            FavoScheduleVC.favoScheduleTableView.reloadData()
        }
    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // cellの選択を解除する
            // これがないとセルを選択した時グレーになり続ける
            cell.isSelected = false
        }
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        // お気に入りされている場合のみ、テキストを設定し、お気に入りイメージを追加する
        if userDefaults.bool(forKey: items[indexPath.row]["id"].string!) == true {
            cell.textLabel?.text = items[indexPath.row]["title"].string
            cell.detailTextLabel?.text = "開催時刻 : \(items[indexPath.row]["time"].stringValue)"
            cell.imageView?.image = favoIcon
        }
        // セルのイメージにタグを設定
        cell.imageView?.tag = indexPath.row
        
        // アイコンタップ時の関数呼び出しの設定
        let tapFavoIcon = UITapGestureRecognizer(target: self, action: #selector(self.tapFavoIcon))
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(tapFavoIcon)
        
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if userDefaults.bool(forKey: items[indexPath.row]["id"].string!) == true {
            return 70
        } else {
            return 0
        }
    }
    
    func tapFavoIcon(gestureRecognizer: UITapGestureRecognizer) {
        // タップしたセルの行番号取得
        let rowNum = gestureRecognizer.view?.tag
        
        // お気に入り登録されていればそれを解除、されてなければ登録
        if userDefaults.bool(forKey: items[rowNum!]["id"].string!) == true {
            userDefaults.set(false, forKey: items[rowNum!]["id"].string!)
        } else {
            userDefaults.set(true, forKey: items[rowNum!]["id"].string!)
        }
        // 各テーブルビューをリロード
        AllScheduleVC.allScheduleTableView.reloadData()
        FavoScheduleVC.favoScheduleTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
