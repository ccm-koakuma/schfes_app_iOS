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

extension UIImage{
    // Resizeするクラスメソッド.
    func ResizeÜIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // コンテキストに自身に設定された画像を描画する.
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アイコンを追加し、アイコンを押したときに"TapMenu()"が実行されるように指定
//        let menu: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu_icon"), style:UIBarButtonItemStyle.plain, target:self, action:#selector(self.TapMenu))
//        let menu_icon: UIImage = UIImage(named: "menu_icon")!
//        menu_icon.withRenderingMode(.alwaysOriginal)
////        print(menu_icon.renderingMode)
//        
//        let menu = UIBarButtonItem(image: menu_icon, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.TapMenu))
//        // ナビゲーションバーにアイコンを追加
        
        let button = UIBarButtonItem()
        button.image = UIImage(named: "menu_icon.png")?.ResizeÜIImage(width: 50, height: 50).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        button.style = UIBarButtonItemStyle.plain
        button.action = #selector(self.TapMenu)
        button.target = self
        self.navigationItem.rightBarButtonItem = button
        
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
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/feed";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                self.items.append(data)
            }
            tableView.reloadData()
        }
    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(items[indexPath.row])")
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items[indexPath.row]["title"].string
//        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row]["send_date"].stringValue)"
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
