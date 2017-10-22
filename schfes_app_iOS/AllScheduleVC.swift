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
    let size40 = CGSize(width: 40, height: 40)
    // お気に入り時の画像
    var favoIcon = UIImage()
    // 非お気に入り時の画像
    var noFavoIcon = UIImage()
    
    // お気に入り登録しているかどうかの値を保持する変数
    // アプリが落ちても値を保持できるUserDefaultsを使用
    let userDefaults = UserDefaults.standard
    
    // FavoScheduleVCからリロードできるようにするため、staticに設定
    static let allScheduleTableView: UITableView = UITableView()
    
    // 1日目と２日目の企画の配列の作成
    var dayOneEvent: [JSON] = []
    var dayTwoEvent: [JSON] = []
    // 前夜祭用
    var eveEvent: [JSON] = []
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["前夜祭", "10月28日", "10月29日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
//        extendedLayoutIncludesOpaqueBars = true
        
        AllScheduleVC.allScheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        AllScheduleVC.allScheduleTableView.delegate = self
        AllScheduleVC.allScheduleTableView.dataSource = self
        // Cell名の登録をおこなう.
        AllScheduleVC.allScheduleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventTableCell")
        AllScheduleVC.allScheduleTableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(AllScheduleVC.allScheduleTableView)
        
        // 青のビューの左端は、親ビューの左端から30ptの位置
        AllScheduleVC.allScheduleTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        AllScheduleVC.allScheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        // 青のビューの幅は、親ビューの幅の1/4
        AllScheduleVC.allScheduleTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        AllScheduleVC.allScheduleTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        // お気に入り時の画像
        favoIcon = (UIImage(named: "favo_icon.png")?.ResizeUIImage(size: size40).withRenderingMode(.alwaysOriginal))!
        // 非お気に入り時の画像
        noFavoIcon = (UIImage(named: "no_favo_icon.png")?.ResizeUIImage(size: size40).withRenderingMode(.alwaysOriginal))!
        
        // データを取得
        let listUrl = "http://150.95.142.204/app2017/schedule";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                // それぞれの日の企画の配列にデータを追加
                if data["date"] == "28"{
                    self.dayOneEvent.append(data)
                } else if data["date"] == "29" {
                    self.dayTwoEvent.append(data)
                } else if data["date"] == "27" {
                    self.eveEvent.append(data)
                }
            }
            // テーブルビューのリロード
            AllScheduleVC.allScheduleTableView.reloadData()
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
            if cell.textLabel?.text == "クイズ&ビンゴ" {
                self.performSegue(withIdentifier: "allToBingo", sender: indexPath.row)
            }
        }
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルの作成
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "EventTableCell")
        
        
        var event:[JSON] = []
        if indexPath.section == 1{
            event = dayOneEvent
            // セルのイメージにタグを設定
            let tagStr: String = "1" + String(indexPath.row)
            let tagNum: Int = Int(tagStr)!
            cell.imageView?.tag = tagNum
        } else if indexPath.section == 2 {
            event = dayTwoEvent
            // セルのイメージにタグを設定
            let tagStr: String = "2" + String(indexPath.row)
            let tagNum: Int = Int(tagStr)!
            cell.imageView?.tag = tagNum
        } else if indexPath.section == 0{
            event = eveEvent
            // セルのイメージにタグを設定
            let tagStr: String = "3" + String(indexPath.row)
            let tagNum: Int = Int(tagStr)!
            cell.imageView?.tag = tagNum
        }
        
        // セルのテキストの設定
        cell.textLabel?.text = event[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "開催時刻 : \(event[indexPath.row]["time"].stringValue)\n場所 : \(event[indexPath.row]["location"].stringValue)"
        // detaliTextLabelの行数を自動調整するように
        cell.detailTextLabel?.numberOfLines = 0
        
        // セルの画像設定
        if userDefaults.bool(forKey: event[indexPath.row]["id"].string!) == true {
            cell.imageView?.image = favoIcon
        } else {
            cell.imageView?.image = noFavoIcon
        }
        
        // アイコンタップ時の関数呼び出しの設定
        let tapFavoIcon = UITapGestureRecognizer(target: self, action: #selector(self.tapFavoIcon))
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(tapFavoIcon)
        // ビンゴ以外選択できないようにする
        if cell.textLabel?.text != "クイズ&ビンゴ" {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return eveEvent.count
        } else if section == 1 {
            return dayOneEvent.count
        } else if section == 2 {
            return dayTwoEvent.count
        } else {
            return 0
        }
    }
    
    // セルの高さの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tapFavoIcon(gestureRecognizer: UITapGestureRecognizer) {
        // タップしたセルの行番号取得
        let tagNum = gestureRecognizer.view?.tag
        let tagStr = String(tagNum!)
        let rowNum = Int(tagStr.substring(from: tagStr.index(after: tagStr.startIndex)))
        
        var event: [JSON] = []
        
        if Int(tagStr.substring(to: tagStr.index(after: tagStr.startIndex))) == 1{
            event = dayOneEvent
        } else if Int(tagStr.substring(to: tagStr.index(after: tagStr.startIndex))) == 2 {
            event = dayTwoEvent
        } else if Int(tagStr.substring(to: tagStr.index(after: tagStr.startIndex))) == 3 {
            event = eveEvent
        } else {
            event = []
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
        SettingMenuVC.setNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 戻るボタンで戻ってきた時の処理
    // これをつけることによってどこをタップしてきたのかわかりやすくする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = AllScheduleVC.allScheduleTableView.indexPathForSelectedRow {
            AllScheduleVC.allScheduleTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}
