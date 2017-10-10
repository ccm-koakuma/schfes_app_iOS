//
//  TopVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class TopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items: JSON = []
    var images: [UIImage] = []
    private var myButton: UIButton!
    private var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // オレンジカラー作成
        let red: CGFloat = 235
        let green: CGFloat = 97
        let blue: CGFloat = 0
        let orangeColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
        

        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        let tableX: CGFloat = 0
        let tableY: CGFloat = UIScreen.main.bounds.size.height*5/10
        let tableWidth: CGFloat = self.view.frame.width
        let tableHeight: CGFloat = UIScreen.main.bounds.size.height*3/10
        
        // ツイートボタンの高さ、幅等
        let tButtonX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let tButtonY: CGFloat = tableY + tableHeight + 20
        let tButtonWidth: CGFloat = 200
        let tButtonHeight: CGFloat = 40
        
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        let tweetImage = UIImage(named: "images/setting_icon.png")?.ResizeUIImage(width: 30, height: 30)
        

    
        
        // -----------------------------------設定ボタンの追加-----------------------------------
        let button = UIBarButtonItem()
        button.image = UIImage(named: "images/setting_icon.png")?.ResizeUIImage(width: 30, height: 30)
        button.style = UIBarButtonItemStyle.plain
        button.action = #selector(self.TapMenu)
        button.target = self
        self.navigationItem.rightBarButtonItem = button
        
        // -----------------------------------See allボタンの作成-----------------------------------
        let allNewsButton = UIButton()
        // ボタンの設置座標とサイズを設定する.
        allNewsButton.frame = CGRect(x: posX, y: UIScreen.main.bounds.size.height*3/10, width: bWidth, height: bHeight)
        // ボタンの背景色を設定.
        allNewsButton.backgroundColor = UIColor.red
        // ボタンの枠を丸くする.
        allNewsButton.layer.masksToBounds = true
        // コーナーの半径を設定する.
        allNewsButton.layer.cornerRadius = 20.0
        // タイトルを設定する(通常時).
        allNewsButton.setTitle(">See all", for: .normal)
        allNewsButton.setTitleColor(UIColor.white, for: .normal)
        // ボタンにタグをつける.
        allNewsButton.tag = 1
        // イベントを追加する
        allNewsButton.addTarget(self, action: #selector(self.onClickAllNewsButton), for: .touchUpInside)
        // ボタンをViewに追加.
        self.view.addSubview(allNewsButton)
        
        // -----------------------------------TableViewを作成-----------------------------------
        let tableView = UITableView()
        tableView.frame = CGRect(x: tableX, y: tableY, width: tableWidth, height: tableHeight)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // テーブルビューの外枠の設定
        tableView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        tableView.layer.borderWidth = 1
        self.view.addSubview(tableView)
        
        // -----------------------------------ツイートするボタンの作成-----------------------------------
        let tweetButton = UIButton()
        // ボタンの設置座標とサイズを設定する.
        tweetButton.frame = CGRect(x: tButtonX, y: tButtonY, width: tButtonWidth, height: tButtonHeight)
        // ボタンの背景色を設定.
        tweetButton.backgroundColor = orangeColor
        // ボタンの枠を丸くする.
        tweetButton.layer.masksToBounds = true
        // コーナーの半径を設定する.
        tweetButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        tweetButton.setTitle("会場の様子をツイート！", for: .normal)
        tweetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        tweetButton.setImage(tweetImage, for: .normal)
        tweetButton.setTitleColor(UIColor.white, for: .normal)
        // ボタンにタグをつける.
        tweetButton.tag = 1
        // イベントを追加する
        tweetButton.addTarget(self, action: #selector(self.Tweet), for: .touchUpInside)
        // ボタンをViewに追加.
        self.view.addSubview(tweetButton)
        
        // -----------------------------------New'sラベルの作成-----------------------------------
        let newsLabel: UILabel = UILabel(frame: CGRect(x: 10, y:65, width: 100, height: bHeight))
        newsLabel.text = "New's"
        newsLabel.textAlignment = NSTextAlignment.left
        newsLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(newsLabel)
        
        // -----------------------------------みんなの反応ラベルの作成-----------------------------------
        let tweetLabel: UILabel = UILabel(frame: CGRect(x: 10, y: tableY-bHeight, width: 200, height: bHeight))
        tweetLabel.text = "みんなの反応"
        tweetLabel.textAlignment = NSTextAlignment.left
        tweetLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(tweetLabel)
        
        
        
        // -----------------------------------TwitterAPI関連-----------------------------------
        if let session = Twitter.sharedInstance().sessionStore.session() {
//            print(session.userID)
            var clientError: NSError?
            
            // ハッシュタグで検索した結果を取得
            let apiClient = TWTRAPIClient(userID: session.userID)
            let request = apiClient.urlRequest(
                withMethod: "GET",
                url: "https://api.twitter.com/1.1/search/tweets.json?q=%23%e3%82%b5%e3%83%83%e3%82%ab%e3%83%bc%e6%97%a5%e6%9c%ac%e4%bb%a3%e8%a1%a8&lang=ja&result_type=mixed",
                parameters: [
                    "user_id": session.userID,
                    "count": "100", // Intで10を渡すとエラーになる模様で、文字列にしてやる必要がある
                ],
                error: &clientError
            )
            
            // ここで通信を行いdataを取得する
            apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    self.items = JSON(data: data)
//                    print(self.items)
                    
                    self.items["statuses"].forEach{(_, data) in
//                        print(data)
                        let urlString = data["user"]["profile_image_url"].string
                        // 画像取得
                        Alamofire.request(urlString!).responseImage { response in
                            if let image = response.result.value {
                                self.images.append(image)
                            }
                            tableView.reloadData()
                        }
                    }
                    tableView.reloadData()
                }
            }
            
        } else {
            print("アカウントはありません")
            Twitter.sharedInstance().logIn { session, error in
                guard let session = session else {
                    if let error = error {
                        print("エラーが起きました => \(error.localizedDescription)")
                    }
                    return
                }
                print("@\(session.userName)でログインしました")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // -----------------------------------ここからテーブルビュー設定用の関数-----------------------------------
    
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.textLabel?.text = items["statuses"][indexPath.row]["text"].string
        cell.textLabel?.numberOfLines = 0
        if images.count-1 >= indexPath.row {
            cell.imageView?.image = images[indexPath.row]
        }
//        print(self.items["statuses"][indexPath.row])
        print("indexPath.row : " + String(indexPath.row))
        print("text : " + (cell.textLabel?.text!)!)

        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("items : " + String(items["statuses"].count))
        print("images : " + String(images.count))
        return items["statuses"].count
    }
    
    // サイズの指定
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    
    
    /*
     ボタンのイベント.
     */
    func onClickAllNewsButton() {
        self.performSegue(withIdentifier: "toNews", sender: nil)
    }

    func Tweet() {
    }
    
    func TapMenu() {
        print("メニューがタップされました")
    }

}

