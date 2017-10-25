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
    var newsImages: [String: UIImage] = [:]
    
    // TableViewを作成
    let newsTableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        self.title = "News"
        
        newsTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.tableFooterView = UIView(frame: .zero)
        
        // プルダウンしたら画面が更新するよう設定
        newsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        self.view.addSubview(newsTableView)
        
        getNews()
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
        if indexPath.row < newsItems.count {
            cell.textLabel?.text = newsItems[indexPath.row]["title"].string
            cell.imageView?.image = newsImages[newsItems[indexPath.row]["id"].string!]?.cropImage(image: newsImages[newsItems[indexPath.row]["id"].string!]!, w: 400, h: 400)
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
    
    func getNews() {
        // URLキャッシュを削除
        URLCache.shared.removeAllCachedResponses()
        // 配列を一旦空に
        self.newsItems = []
        self.newsImages = [:]
        // JSON取得
        let listUrl = "http://150.95.142.204/app2017/feed";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(_, data) in
                self.newsItems.append(data)
            }
            self.newsTableView.reloadData()
            
            var count = 0
            
            for newsItem in self.newsItems {
                // Set Image URL
                let urlString = newsItem["picture"].string
                // 画像取得
                Alamofire.request(urlString!).responseImage { response in
                    if let image = response.result.value {
                        self.newsImages[newsItem["id"].string!] = image
                        count += 1
                    }
                    self.newsTableView.reloadData()
                }
            }
        }
    }
    
    func refresh() {
        getNews()
        self.refreshControl.endRefreshing()
        
    }
}
