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
    
    var tweetItems: JSON = []
    var tweetImages: [UIImage] = []
    
    var newsItems: [JSON] = []
    var newsImages: [UIImage] = []
    
    private var myButton: UIButton!
    private var tweetButton: UIButton!
    
    var newsLink1: String = ""
    var newsLink2: String = ""
    var newsLink3: String = ""
    
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
        
        // -----------------------------------New'sラベルの作成-----------------------------------
        let newsLabelY: CGFloat = 65
        let newsLabel: UILabel = UILabel(frame: CGRect(x: 10, y:newsLabelY, width: bWidth, height: bHeight))
        newsLabel.text = "New's"
        newsLabel.textAlignment = NSTextAlignment.left
        newsLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(newsLabel)
        
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        let tweetImage = UIImage(named: "images/setting_icon.png")?.ResizeUIImage(width: 30, height: 30)
        
        // ----------------------------------ニュースの画像-----------------------------------
        
        let newsImage1X: CGFloat = UIScreen.main.bounds.size.width*1/10
        let newsImageY: CGFloat = newsLabelY + bHeight
        
        let newsImage2X: CGFloat = UIScreen.main.bounds.size.width*4/10
        
        let newsImage3X: CGFloat = UIScreen.main.bounds.size.width*7/10
        let newsImageWidth: CGFloat = UIScreen.main.bounds.size.width*2/10
        let newsImageHeight: CGFloat = newsImageWidth
        let news1: UIImageView = UIImageView(frame:  CGRect(x: newsImage1X, y: newsImageY, width: newsImageWidth, height: newsImageHeight))
        let news2: UIImageView = UIImageView(frame:  CGRect(x: newsImage2X, y: newsImageY, width: newsImageWidth, height: newsImageHeight))
        let news3: UIImageView = UIImageView(frame:  CGRect(x: newsImage3X, y: newsImageY, width: newsImageWidth, height: newsImageHeight))
        
        // 画像の角を丸くする
        news1.clipsToBounds = true
        news1.layer.cornerRadius = 5.0
        news2.clipsToBounds = true
        news2.layer.cornerRadius = 5.0
        news3.clipsToBounds = true
        news3.layer.cornerRadius = 5.0
        
        // タップを定義
        let newsTap1 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink1))
        let newsTap2 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink2))
        let newsTap3 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink3))
        
        // タップを検知できるようにする
        news1.isUserInteractionEnabled = true
        news2.isUserInteractionEnabled = true
        news3.isUserInteractionEnabled = true
        // viewにタップを登録
        news1.addGestureRecognizer(newsTap1)
        news2.addGestureRecognizer(newsTap2)
        news3.addGestureRecognizer(newsTap3)
        
        // ----------------------------------ニュースタイトルの設定-----------------------------------
        let newsTitleWidth: CGFloat = newsImageWidth
        let newsTitleHeight: CGFloat = 40
        let newsTitleY: CGFloat = newsImageY + newsImageHeight
        let newsTitle1X: CGFloat = newsImage1X
        let newsTitle2X: CGFloat = newsImage2X
        let newsTitle3X: CGFloat = newsImage3X
        let newsTitle1 = UILabel(frame: CGRect(x: newsTitle1X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight))
        let newsTitle2 = UILabel(frame: CGRect(x: newsTitle2X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight))
        let newsTitle3 = UILabel(frame: CGRect(x: newsTitle3X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight))
        
        newsTitle1.textAlignment = NSTextAlignment.center
        newsTitle2.textAlignment = NSTextAlignment.center
        newsTitle3.textAlignment = NSTextAlignment.center
        
//        newsTitle1.text = "hoge1"
//        newsTitle2.text = "hoge2"
//        newsTitle3.text = "hoge3"
        
        
        
        //        if newsImages.count-1 > 0{
        //            news1.image = newsImages[newsImages.count-1]
        //        }

        func setImage(response: DataResponse<Any>) ->Void {
            let json = JSON(response.result.value ?? "")
            let newsImageURL1 = json[json.count-1]["picture"].string
            let newsImageURL2 = json[json.count-2]["picture"].string
            let newsImageURL3 = json[json.count-3]["picture"].string
            
            Alamofire.request(newsImageURL1!).responseImage { response in
                if let image = response.result.value {
                    let newsImage1 = image.cropImage(image: image, w: 300, h: 300)
                    news1.image = newsImage1
                    newsTitle1.text = json[json.count-1]["id"].string
                    self.newsLink1 = json[json.count-1]["link"].string!
                }
            }
            Alamofire.request(newsImageURL2!).responseImage { response in
                if let image = response.result.value {
                    let newsImage2 = image.cropImage(image: image, w: 300, h: 300)
                    news2.image = newsImage2
                    newsTitle2.text = json[json.count-2]["id"].string
                    self.newsLink2 = json[json.count-2]["link"].string!
                }
            }
            Alamofire.request(newsImageURL3!).responseImage { response in
                if let image = response.result.value {
                    let newsImage3 = image.cropImage(image: image, w: 300, h: 300)
                    news3.image = newsImage3
                    newsTitle3.text = json[json.count-3]["id"].string
                    self.newsLink3 = json[json.count-3]["link"].string!
                }
            }
            
        }
        // JSON取得
        let listUrl = "http://ytrw3xix.0g0.jp/app2017/feed";
        Alamofire.request(listUrl).responseJSON(completionHandler: setImage)
        

        self.view.addSubview(news1)
        self.view.addSubview(news2)
        self.view.addSubview(news3)
        self.view.addSubview(newsTitle1)
        self.view.addSubview(newsTitle2)
        self.view.addSubview(newsTitle3)
        

        // -----------------------------------設定ボタンの追加-----------------------------------
        let button = UIBarButtonItem()
        button.image = UIImage(named: "images/setting_icon.png")?.ResizeUIImage(width: 30, height: 30)
        button.style = UIBarButtonItemStyle.plain
        button.action = #selector(self.TapMenu)
        button.target = self
        self.navigationItem.rightBarButtonItem = button
        
        // -----------------------------------See allボタンの作成-----------------------------------
        let allNewsButton = UIButton()
        let allNewsButtonWidth: CGFloat = 100
        let allNewsButtonHeight: CGFloat =  33
        let allNewsButtonX: CGFloat = UIScreen.main.bounds.size.width*19/20 - allNewsButtonWidth
        let allNewsButtonY: CGFloat = newsTitleY + newsTitleHeight
        
        // ボタンの設置座標とサイズを設定する.
        allNewsButton.frame = CGRect(x: allNewsButtonX, y: allNewsButtonY, width: allNewsButtonWidth, height: allNewsButtonHeight)
        // ボタンの背景色を設定.
//        allNewsButton.backgroundColor = UIColor.red
        // ボタンの枠を丸くする.
//        allNewsButton.layer.masksToBounds = true
        // コーナーの半径を設定する.
//        allNewsButton.layer.cornerRadius = 20.0
        // タイトルを設定する(通常時).
//        allNewsButton.setTitle(">See all", for: .normal)
//        allNewsButton.setTitleColor(UIColor.white, for: .normal)
        
        // ボタンに画像を設定する
        let seeAllImage = UIImage(named: "images/see_all.png")?.ResizeUIImage(width: 100, height: 33)
        allNewsButton.setImage(seeAllImage, for: .normal)
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
        tweetButton.tag = 2
        // イベントを追加する
        tweetButton.addTarget(self, action: #selector(self.Tweet), for: .touchUpInside)
        // ボタンをViewに追加.
        self.view.addSubview(tweetButton)

        
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
                    self.tweetItems = JSON(data: data)
//                    print(self.tweetItems)
                    
                    self.tweetItems["statuses"].forEach{(_, data) in
//                        print(data)
                        let urlString = data["user"]["profile_image_url"].string
                        // 画像取得
                        Alamofire.request(urlString!).responseImage { response in
                            if let image = response.result.value {
                                self.tweetImages.append(image)
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
        cell.textLabel?.text = tweetItems["statuses"][indexPath.row]["text"].string
        cell.textLabel?.numberOfLines = 0
        if tweetImages.count-1 >= indexPath.row {
            cell.imageView?.image = tweetImages[indexPath.row]
        }
//        print(self.tweetItems["statuses"][indexPath.row])
//        print("indexPath.row : " + String(indexPath.row))
//        print("text : " + (cell.textLabel?.text!)!)

        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("tweetItems : " + String(tweetItems["statuses"].count))
//        print("tweetImages : " + String(tweetImages.count))
        return tweetItems["statuses"].count
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
        print("tweetボタンが押されました")
    }
    
    func TapMenu() {
        print("メニューがタップされました")
    }
    
    /// viewをタップされた時の処理
    func toNewsLink1(){
        print("1")
        if let url = NSURL(string: newsLink1) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    func toNewsLink2(){
        print("2")
        if let url = NSURL(string: newsLink2) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    func toNewsLink3(){
        print("3")
        if let url = NSURL(string: newsLink3) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
