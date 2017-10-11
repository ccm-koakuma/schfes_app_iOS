//
//  NewsVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // newsItemsをJSONの配列と定義
    var newsItems: [JSON] = []
    var newsImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        
        // TableViewを作成
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        // JSON取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/feed";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                self.newsItems.append(data)
                // Set Image URL
                let urlString = data["picture"].string
                // 画像取得
                Alamofire.request(urlString!).responseImage { response in
                    if let image = response.result.value {
                        self.newsImages.append(image)
                    }
                    tableView.reloadData()
                }
            }
            tableView.reloadData()
        }

    }
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let url = NSURL(string: newsItems[indexPath.row]["link"].string!) {
            UIApplication.shared.openURL(url as URL)
        }
        
        cell?.isSelected = false
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = newsItems[indexPath.row]["title"].string
//        cell.detailTextLabel?.text = "投稿日時 : \(newsItems[indexPath.row]["date"].stringValue)"
        cell.detailTextLabel?.text = "投稿日時 : 2017/09/24)"
        // 画像がダウンロードできていれば表示
        if newsImages.count-1 >= indexPath.row {
            cell.imageView?.image = newsImages[indexPath.row]
        }
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    // サイズの指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
