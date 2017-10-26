//
//  SettingMenu.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/15.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// 通知機能の実装
import UserNotifications
import NotificationCenter

class SettingMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    var items: [JSON] = []
    
    // Tableで使用する配列を設定する
    private let settingItems: NSArray = ["設定", "通知機能", "アプリの使い方", "CCMとは？"]
    private var settingTableView: UITableView!
    
    // オレンジカラー作成
    let orangeColor = UIColor(red: 235/255.0, green: 97/255.0, blue: 0/255.0, alpha: 1)
    
    // UserDefaultsに登録用の文字列、スペルミスしないようにね☆
    let notificationStr = "notification"
    let notificationEnabledStr = "notificationEnabled"
    
    // 通知機能の許可、不許可を切り替えるスイッチ
    let notificationSwitch = UISwitch()
    
    // 通知が許可されているかどうかの値を保持する変数
    // アプリが落ちても値を保持できるUserDefaultsを使用
    let userDefaults = UserDefaults.standard
    
    
    let isNotFirst = "isFirst2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "設定"
        
        
        //-----------------------------------------------------------通知の設定-----------------------------------------------------------
        // 通知の許可を得るコード
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("通知許可")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                    // 通知機能を許可状態にする
                    self.userDefaults.set(true, forKey: self.notificationEnabledStr)
                    
                    self.setNotificationSwitch()
                    
                } else {
                    print("通知拒否")
                    
                    // 通知機能を不許可状態にする
                    self.userDefaults.set(false, forKey: self.notificationEnabledStr)
                    self.userDefaults.set(false, forKey: self.notificationStr)
                    
                    self.setNotificationSwitch()
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        tableCreate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     Cellが選択された際に呼び出される
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.toHowToUse()
        } else if indexPath.row == 3 {
            self.toAboutCCM()
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
            // 選択できないようにする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            // フォントの設定
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
            // テキストを中心に
            cell.textLabel?.textAlignment = .center
            // 文字色と背景色の設定
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = orangeColor
        } else if indexPath.row == 1 {
            // 選択できないようにする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            // 右側にスイッチを配置
            cell.accessoryView = self.notificationSwitch
            
        } else {
            // 右側のアクセサリを設定
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
    
    // 通知機能の切り替えスイッチが押された時のメソッド
    func tapNotificationSettings() {
        // 通知が許可されているかどうかの値を保持する変数
        // アプリが落ちても値を保持できるUserDefaultsを使用
        let userDefaults = UserDefaults.standard
        
        if self.notificationSwitch.isOn == true {
            userDefaults.set(true, forKey: self.notificationStr)
            SettingMenuVC.setNotification()
            print("通知がセットされたよ！")
        } else {
            userDefaults.set(false, forKey: self.notificationStr)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("通知が全削除されたよ！")
        }
    }
    
    
    static func setNotification() {
        // とりあえず一回全削除
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        
        // JSON取得
        let listUrl = "http://150.95.142.204/app2017/schedule";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(arg) in
                
                let (_, data) = arg
                let userDefaults = UserDefaults.standard
                if userDefaults.bool(forKey: data["id"].string!) == true {
                    // トリガー設定(時間を指定したい場合これ)
                    notificationTime.month = 10
                    notificationTime.day = Int(String(describing: data["date"]))
                    notificationTime.hour = Int(String(describing: data["time"]).components(separatedBy: ":")[0])
                    if Int(String(describing: data["time"]).components(separatedBy: ":")[1])! == 0 {
                        notificationTime.minute = 50
                        notificationTime.hour = notificationTime.hour!-1
                    } else {
                        notificationTime.minute = Int(String(describing: data["time"]).components(separatedBy: ":")[1])!-10
                    }
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                    
                    let notifiId: String = String(describing: data["id"])
                    
                    content.title = "イベントの時間が近づいてきました！"
                    content.body = "\(data["time"])から\(data["location"])で\(data["title"])が開始されます！"
                    content.sound = UNNotificationSound.default()
                    print("\(data["time"])から\(data["location"])で\(data["title"])が開始されます！")
                    
                    let request = UNNotificationRequest(identifier: notifiId, content: content, trigger: trigger)
                    
                    // 通知をセット
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    print("hoge" + String(describing: data))
                    print(notificationTime)
                }
            }
        }
        
        
        print("setNotification")
    }
    
    func setNotificationSwitch() {
        
        print("setNotification")
        print(userDefaults.bool(forKey: "notificationEnabled"))
        print(userDefaults.bool(forKey: "notification"))
        
        if userDefaults.bool(forKey: "notificationEnabled") == true {
            self.notificationSwitch.isEnabled = true
            if userDefaults.bool(forKey: "notification") == true {
                print("switch ON")
                self.notificationSwitch.isOn = true
            } else {
                self.notificationSwitch.isOn = false
            }
        } else{
            self.notificationSwitch.isOn = false
            self.notificationSwitch.isEnabled = false
        }
    }
    
    
    func toHowToUse() {
        let storyboard: UIStoryboard = self.storyboard!
        let howToUseVC = storyboard.instantiateViewController(withIdentifier: "HowToUseVC")
        let howToUseNavi = UINavigationController(rootViewController: howToUseVC)
        present(howToUseNavi, animated: true, completion: nil)
    }
    func toAboutCCM() {
        let storyboard: UIStoryboard = self.storyboard!
        let aboutCCMVC = storyboard.instantiateViewController(withIdentifier: "AboutCCMVC")
        let aboutCCMNavi = UINavigationController(rootViewController: aboutCCMVC)
        present(aboutCCMNavi, animated: true, completion: nil)
    }
    // 戻るボタンで戻ってきた時の処理
    // これをつけることによってどこをタップしてきたのかわかりやすくする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = self.settingTableView.indexPathForSelectedRow {
            self.settingTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    func tableCreate() {
        if userDefaults.bool(forKey: notificationStr) == true {
            // 通知をセット
            SettingMenuVC.setNotification()
        }
        
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
        
        if self.userDefaults.bool(forKey: self.isNotFirst) == true {
            setNotificationSwitch()
        }
        
        self.notificationSwitch.addTarget(self, action: #selector(self.tapNotificationSettings), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }
}
