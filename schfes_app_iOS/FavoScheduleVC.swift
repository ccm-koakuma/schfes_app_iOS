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
    let favoIcon = UIImage(named: "favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    // 非お気に入り時の画像
    let noFavoIcon = UIImage(named: "no_favo_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
    
    // お気に入り登録しているかどうかの値を保持する変数
    // アプリが落ちても値を保持できるUserDefaultsを使用
    let userDefaults = UserDefaults.standard
    
    // AllScheduleVCからリロードできるようにするため、staticに設定
    static let favoScheduleTableView: UITableView = UITableView()
    
    // 1日目と２日目の企画の配列の作成
    var day_one_event: [JSON] = []
    var day_two_event: [JSON] = []
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["10月28日", "10月29日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの設定
        FavoScheduleVC.favoScheduleTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        FavoScheduleVC.favoScheduleTableView.delegate = self
        FavoScheduleVC.favoScheduleTableView.dataSource = self
        FavoScheduleVC.favoScheduleTableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(FavoScheduleVC.favoScheduleTableView)
        
        // データを取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/timetable";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                // それぞれの日の企画の配列にデータを追加
                if data["time"] == "301430"{
                    self.day_one_event.append(data)
                } else {
                    self.day_two_event.append(data)
                }
            }
            // テーブルビューのリロード
            FavoScheduleVC.favoScheduleTableView.reloadData()
        }
    }
    
    
    //セクションの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    //セクションのタイトルを返す.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section] as? String
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
        
        var event:[JSON] = []
        if indexPath.section == 0{
            event = day_one_event
            // セルのイメージにタグを設定
            let tagstr: String = "1" + String(indexPath.row)
            cell.imageView?.tag = Int(tagstr)!
        } else {
            event = day_two_event
            // セルのイメージにタグを設定
            let tagstr: String = "2" + String(indexPath.row)
            cell.imageView?.tag = Int(tagstr)!
        }
    
        // お気に入りされている場合のみ、テキストを設定し、お気に入りイメージを追加する
        if userDefaults.bool(forKey: event[indexPath.row]["id"].string!) == true {
            cell.textLabel?.text = event[indexPath.row]["title"].string
            cell.detailTextLabel?.text = "開催時刻 : \(event[indexPath.row]["time"].stringValue)"
            cell.imageView?.image = favoIcon
        }
        
        // アイコンタップ時の関数呼び出しの設定
        let tapFavoIcon = UITapGestureRecognizer(target: self, action: #selector(self.tapFavoIcon))
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(tapFavoIcon)
        
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return day_one_event.count
        } else if section == 1 {
            return day_two_event.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var event:[JSON] = []
        
        if indexPath.section == 0{
            event = day_one_event
        } else {
            event = day_two_event
        }
        
        if userDefaults.bool(forKey: event[indexPath.row]["id"].string!) == true {
            return 70
        } else {
            return 0
        }
    }
    
    func tapFavoIcon(gestureRecognizer: UITapGestureRecognizer) {
        // タップしたセルの行番号取得
        let tagNum = gestureRecognizer.view?.tag
        let tagStr = String(tagNum!)
        let rowNum = Int(tagStr.substring(from: tagStr.index(after: tagStr.startIndex)))
        
        var event: [JSON] = []

        if Int(tagStr.substring(to: tagStr.index(after: tagStr.startIndex))) == 1{
            event = day_one_event
        } else {
            event = day_two_event
        }
        // お気に入り登録されていればそれを解除、されてなければ登録
        if userDefaults.bool(forKey: event[rowNum!]["id"].string!) == true {
            userDefaults.set(false, forKey: event[rowNum!]["id"].string!)
        } else {
            userDefaults.set(true, forKey: event[rowNum!]["id"].string!)
        }
        // 各テーブルビューをリロード
        AllScheduleVC.allScheduleTableView.reloadData()
        FavoScheduleVC.favoScheduleTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
