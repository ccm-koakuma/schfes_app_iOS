//
//  TopVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SlideMenuControllerSwift
import SwiftyJSON
import TwitterKit

class TopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let size30 = CGSize(width: 30, height: 30)

    // オレンジカラー作成
    let orangeColor = UIColor(red: 235/255.0, green: 97/255.0, blue: 0/255.0, alpha: 1)
    let twitterColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1)
    
    // ボタンのサイズを定義.
    let bWidth: CGFloat = 200
    let bHeight: CGFloat = 50
    
    // ツイッターのデータを入れておく配列
    var tweetItems: JSON = []
    // ツイッターの画像を入れておく配列
    var tweetImages: [UIImage] = []
    
    // ツイッターのアイコンイメージ
    let tweetImage = (UIImage(named: "twitter.png")?.ResizeUIImage(size: CGSize(width: 30, height: 30)))!
    
    // ニュースのデータを入れておく配列
    var newsItems: [JSON] = []
    // ニュースの画像を入れておく配列
    var newsImages: [UIImage] = []
    
    var isTwitterAuthorization: Bool = false
    
    // 画面上部にあるニュースのリンク
    var newsLink1: String = ""
    var newsLink2: String = ""
    var newsLink3: String = ""
    
    
    // ツイッターの検索結果を表示するテーブルビュー作成
    let tweetTableView = UITableView()
    
    // ツイートするボタン
    let tweetButton: UIButton = UIButton()
    
    let tweetLabel: UILabel = UILabel()
    
    // ツイッター認証するボタン
    let twitterAuthorizationButton: UIButton = UIButton()
    
    // ニュース画像のインスタンス生成
    let news1: UIImageView = UIImageView()
    let news2: UIImageView = UIImageView()
    let news3: UIImageView = UIImageView()
    
    // ニュースタイトルのインスタンス生成
    let newsTitle1: UILabel = UILabel()
    let newsTitle2: UILabel = UILabel()
    let newsTitle3:UILabel = UILabel()
    // ツイッターAPIで飛ばすURL
    let searchWord: String = "%0a%23%e7%9c%8c%e5%a4%a7%e7%a5%adtpu2017"
    var twitterApiUrl: String = "https://api.twitter.com/1.1/search/tweets.json"
    let searchQuery: String = "#県大祭tpu2017  exclude:retweets"
    
    // リフレッシュコントロールの変数
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true

        // -----------------------------------settingボタンの設定-----------------------------------
        // 設定ボタンの各種座標、大きさの設定
        let settingImage = UIImage(named: "setting_icon.png")?.ResizeUIImage(size: size30)
        
        let settingIcon = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(self.onMenu))
        self.navigationItem.rightBarButtonItem = settingIcon
        
        
        // -----------------------------------New'sラベルの作成-----------------------------------
        let newsLabelY: CGFloat = 65
        let newsLabel: UILabel = UILabel(frame: CGRect(x: 10, y:newsLabelY, width: bWidth, height: bHeight))
        newsLabel.text = "New's"
        newsLabel.textAlignment = NSTextAlignment.left
        newsLabel.font = UIFont.systemFont(ofSize: 15)
        newsLabel.numberOfLines = 0
        self.view.addSubview(newsLabel)
        
        
        // ----------------------------------ニュースの画像-----------------------------------
        
        // ニュース画像の各種座標、大きさ
        let newsImageY: CGFloat = newsLabelY + bHeight
        let newsImage1X: CGFloat = UIScreen.main.bounds.size.width*1/10
        let newsImage2X: CGFloat = UIScreen.main.bounds.size.width*4/10
        let newsImage3X: CGFloat = UIScreen.main.bounds.size.width*7/10
        
        let newsImageWidth: CGFloat = UIScreen.main.bounds.size.width*2/10
        let newsImageHeight: CGFloat = newsImageWidth
        
        // ニュース画像の座標、大きさ設定
        self.news1.frame = CGRect(x: newsImage1X, y: newsImageY, width: newsImageWidth, height: newsImageHeight)
        self.news2.frame = CGRect(x: newsImage2X, y: newsImageY, width: newsImageWidth, height: newsImageHeight)
        self.news3.frame = CGRect(x: newsImage3X, y: newsImageY, width: newsImageWidth, height: newsImageHeight)
        
        // 画像の角を丸くする
        news1.clipsToBounds = true
        news1.layer.cornerRadius = 5.0
        news2.clipsToBounds = true
        news2.layer.cornerRadius = 5.0
        news3.clipsToBounds = true
        news3.layer.cornerRadius = 5.0
        
        // タップしたときのアクションを定義
        let newsTap1 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink1))
        let newsTap2 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink2))
        let newsTap3 = UITapGestureRecognizer(target: self, action: #selector(self.toNewsLink3))
        
        // タップを検知できるようにする
        news1.isUserInteractionEnabled = true
        news2.isUserInteractionEnabled = true
        news3.isUserInteractionEnabled = true
        // viewにアクションを追加
        news1.addGestureRecognizer(newsTap1)
        news2.addGestureRecognizer(newsTap2)
        news3.addGestureRecognizer(newsTap3)
        
        // ----------------------------------ニュースタイトルの設定-----------------------------------
        
        // ニュースタイトルの各種座標、大きさ設定
        let newsTitleWidth: CGFloat = newsImageWidth
        let newsTitleHeight: CGFloat = 40
        let newsTitleY: CGFloat = newsImageY + newsImageHeight
        let newsTitle1X: CGFloat = newsImage1X
        let newsTitle2X: CGFloat = newsImage2X
        let newsTitle3X: CGFloat = newsImage3X
        
        // ニュースタイトルのインスタンス生成
        newsTitle1.frame = CGRect(x: newsTitle1X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight)
        newsTitle2.frame = CGRect(x: newsTitle2X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight)
        newsTitle3.frame = CGRect(x: newsTitle3X, y: newsTitleY, width: newsTitleWidth, height: newsTitleHeight)
        
        // テキストを中心に配置するよう設定
        newsTitle1.textAlignment = NSTextAlignment.center
        newsTitle2.textAlignment = NSTextAlignment.center
        newsTitle3.textAlignment = NSTextAlignment.center
        
//        //表示可能最大行数を指定
        newsTitle1.numberOfLines = 2
        newsTitle2.numberOfLines = 2
        newsTitle3.numberOfLines = 2
        //contentsのサイズに合わせてobujectのサイズを変える
        //単語の途中で改行されないようにする
        newsTitle1.lineBreakMode = .byWordWrapping
        newsTitle2.lineBreakMode = .byWordWrapping
        newsTitle3.lineBreakMode = .byWordWrapping
        
        // JSON取得
        URLCache.shared.removeAllCachedResponses()
        let listUrl = "http://150.95.142.204/app2017/feed";
        Alamofire.request(listUrl).responseJSON(completionHandler: setNews)
        
        // ビューに貼り付け
        self.view.addSubview(news1)
        self.view.addSubview(news2)
        self.view.addSubview(news3)
        self.view.addSubview(newsTitle1)
        self.view.addSubview(newsTitle2)
        self.view.addSubview(newsTitle3)
        
        
        
        // -----------------------------------See allボタンの作成-----------------------------------
        
        // SeeAllボタンのの各種座標、大きさの設定
        let allNewsButton = UIButton()
        let allNewsButtonWidth: CGFloat = 100
        let allNewsButtonHeight: CGFloat =  33
        let allNewsButtonX: CGFloat = UIScreen.main.bounds.size.width*19/20 - allNewsButtonWidth
        let allNewsButtonY: CGFloat = newsTitleY + newsTitleHeight
        
        // ボタンの設置座標とサイズを設定する.
        allNewsButton.frame = CGRect(x: allNewsButtonX, y: allNewsButtonY, width: allNewsButtonWidth, height: allNewsButtonHeight)
        
        // ボタンに画像を設定する
        let seeAllImage = UIImage(named: "see_all.png")?.ResizeUIImage(size: CGSize(width: 100, height: 33))
        allNewsButton.setImage(seeAllImage, for: .normal)
        // ボタンにタグをつける.
        allNewsButton.tag = 1
        // イベントを追加する
        allNewsButton.addTarget(self, action: #selector(self.toNewsList), for: .touchUpInside)
        // ボタンをViewに追加.
        self.view.addSubview(allNewsButton)
        
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            print(session.authToken)
            // ツイートテーブル＆ツイートボタン作成
            TweetTableCreation()
            // ツイート取得
            getTweet()
        } else {
            self.TaButtonCreate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -----------------------------------ツイートするメソッド-----------------------------------
    func Tweet() {
        let twitterUrlScheme = NSURL(string: "twitter://post?message=" + self.searchWord)!
        let twitterUrl = NSURL(string: "https://twitter.com/intent/tweet?text=" + self.searchWord)!
        if (UIApplication.shared.canOpenURL(twitterUrlScheme as URL)) {
            UIApplication.shared.openURL(twitterUrlScheme as URL)
        } else {
            UIApplication.shared.openURL(twitterUrl as URL)
        }
    }
    
    // -----------------------------------TwitterAPIからツイートの検索結果を取得するメソッド-----------------------------------
    func getTweet(){
        URLCache.shared.removeAllCachedResponses()
        let session = Twitter.sharedInstance().sessionStore.session()
        
        var clientError: NSError?
        print(session)
        // ハッシュタグで検索した結果を取得
        let apiClient = TWTRAPIClient(userID: session!.userID)
        let request = apiClient.urlRequest(
            withMethod: "GET",
            url: self.twitterApiUrl,
            parameters: [
                "user_id": session!.userID,
                "q": searchQuery,
                "count": "100", // Intで10を渡すとエラーになる模様で、文字列にしてやる必要がある
            ],
            error: &clientError
        )
        
        // ここで通信を行いdataを取得する
        apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
            self.tweetImages.removeAll()
            if let error = error {
                print(error.localizedDescription)
                self.tweetTableView.removeFromSuperview()
                self.tweetButton.removeFromSuperview()
                
                Twitter.sharedInstance().sessionStore.logOutUserID((session?.userID)!)
                self.TaButtonCreate()

            } else if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                self.tweetItems = JSON(data: data)
                print(data)
                //                    print(self.tweetItems)
                
                self.tweetItems["statuses"].forEach{(_, data) in
                    //                        print(data)
                    let urlString = data["user"]["profile_image_url"].string
                    // 画像取得
                    Alamofire.request(urlString!).responseImage { response in
                        if let image = response.result.value {
                            self.tweetImages.append(image)
                        }
                        self.tweetTableView.reloadData()
                    }
                }
                self.tweetTableView.reloadData()
            }
        }
    }
    
    // ツイッター認証するメソッド
    func TwitterAuthorization() {
        print("アカウント認証を開始します")
        Twitter.sharedInstance().logIn { session, error in
            guard let session = session else {
                if let error = error {
                    print("エラーが起きました => \(error.localizedDescription)")
                }
                return
            }
            
            print("@\(session.userName)でログインしました")
            self.loadView()
            self.viewDidLoad()
        }
    }
    
    //------------------------------------------------ツイッター部分を作るメソッド------------------------------------------------
    func TweetTableCreation() {
        
        // ツイッターのテーブルビューの位置や大きさ
        let tableX: CGFloat = 0
        let tableY: CGFloat = UIScreen.main.bounds.size.height*5/10
        let tableWidth: CGFloat = self.view.frame.width
        let tableHeight: CGFloat = UIScreen.main.bounds.size.height*3/10
        
        // ツイートボタンの高さ、幅等
        let tButtonX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let tButtonY: CGFloat = tableY + tableHeight + 20
        let tButtonWidth: CGFloat = 200
        let tButtonHeight: CGFloat = 40
        
        // -----------------------------------TableViewを作成-----------------------------------
        
        // テーブルビューの各種座標、大きさ設定
        tweetTableView.frame = CGRect(x: tableX, y: tableY, width: tableWidth, height: tableHeight)
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        // テーブルビューの高さが自動的に変更されるように設定
        tweetTableView.estimatedRowHeight = 10
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        // テーブルビューの外枠の設定
        tweetTableView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        tweetTableView.layer.borderWidth = 1
        
        tweetTableView.tableFooterView = UIView(frame: .zero)
        
        tweetTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TweetCell")
        
        // プルダウンしたら画面が更新するよう設定
        tweetTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        // ビューに貼り付け
        self.view.addSubview(tweetTableView)
        
        // -----------------------------------ツイートするボタンの作成-----------------------------------
        // ボタンの設置座標とサイズを設定する.
        tweetButton.frame = CGRect(x: tButtonX, y: tButtonY, width: tButtonWidth, height: tButtonHeight)
        // ボタンの背景色を設定.
        tweetButton.backgroundColor = self.orangeColor
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
        tweetLabel.frame = CGRect(x: 10, y: tableY-bHeight, width: 200, height: bHeight)
        tweetLabel.text = "みんなの反応"
        tweetLabel.textAlignment = NSTextAlignment.left
        tweetLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(tweetLabel)
    }
    // -----------------------------------ツイッター認証するボタンの作成-----------------------------------
    func TaButtonCreate() {
        // ツイートボタンの高さ、幅等
        let taButtonX: CGFloat = self.view.bounds.width/2 - self.self.bWidth/2
        let taButtonY: CGFloat = UIScreen.main.bounds.size.height*7/10
        let taButtonWidth: CGFloat = 200
        let taButtonHeight: CGFloat = 40
        // ボタンの設置座標とサイズを設定する.
        self.twitterAuthorizationButton.frame = CGRect(x: taButtonX, y: taButtonY, width: taButtonWidth, height: taButtonHeight)
        // ボタンの背景色を設定.
        self.twitterAuthorizationButton.backgroundColor = self.twitterColor
        // ボタンの枠を丸くする.
        self.twitterAuthorizationButton.layer.masksToBounds = true
        // コーナーの半径を設定する.
        self.twitterAuthorizationButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        self.twitterAuthorizationButton.setTitle("ツイッター認証する", for: .normal)
        self.twitterAuthorizationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.twitterAuthorizationButton.setImage(self.tweetImage, for: .normal)
        self.twitterAuthorizationButton.setTitleColor(UIColor.white, for: .normal)
        // ボタンにタグをつける.
        self.twitterAuthorizationButton.tag = 2
        // イベントを追加する
        self.twitterAuthorizationButton.addTarget(self, action: #selector(self.TwitterAuthorization), for: .touchUpInside)
        // ボタンをViewに追加.
        self.view.addSubview(self.twitterAuthorizationButton)
    }
    
    // 設定ボタンがタップされた時のメソッド
    func onMenu(sender: UIButton) {
        self.slideMenuController()?.openRight()
    }
    
    // ニュース部分を設定するメソッド
    func setNews(response: DataResponse<Any>) ->Void {
        let json = JSON(response.result.value ?? "")
        // ニュース画像のリンク
        let newsImageURL1 = json[0]["picture"].string
        let newsImageURL2 = json[1]["picture"].string
        let newsImageURL3 = json[2]["picture"].string
        
        if json[0]["title"].string != nil {
            // 通信して画像持ってきてセット
            Alamofire.request(newsImageURL1!).responseImage { response in
                if let image = response.result.value {
                    let newsImage1 = image.cropImage(image: image, w: 300, h: 300)
                    self.news1.image = newsImage1
                    self.newsTitle1.text = json[0]["title"].string
                    self.newsTitle1.sizeToFit()
                    self.newsLink1 = json[0]["link"].string!
                }
            }
        }
        if json[2]["title"].string != nil {
            Alamofire.request(newsImageURL2!).responseImage { response in
                if let image = response.result.value {
                    let newsImage2 = image.cropImage(image: image, w: 300, h: 300)
                    self.news2.image = newsImage2
                    self.newsTitle2.text = json[1]["title"].string
                    self.newsTitle2.sizeToFit()
                    self.newsLink2 = json[1]["link"].string!
                }
            }
        }
        
        if json[2]["title"].string != nil {
            Alamofire.request(newsImageURL3!).responseImage { response in
                if let image = response.result.value {
                    let newsImage3 = image.cropImage(image: image, w: 300, h: 300)
                    self.news3.image = newsImage3
                    self.newsTitle3.text = json[2]["title"].string
                    self.newsTitle3.sizeToFit()
                    self.newsLink3 = json[2]["link"].string!
                }
            }
        }
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
    
    // -----------------------------------ここからテーブルビュー設定用の関数-----------------------------------
    
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.isSelected = false
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print(indexPath.row)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TweetCell")
        cell.textLabel?.text = tweetItems["statuses"][indexPath.row]["text"].string
        cell.textLabel?.numberOfLines = 0
        if tweetImages.count-1 >= indexPath.row {
            //            cell.imageView?.image = tweetImages[indexPath.row]
        }
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print("tweetItems : " + String(tweetItems["statuses"].count))
        //        print("tweetImages : " + String(tweetImages.count))
        return tweetItems["statuses"].count
    }
    
    // See All ボタンを押した時のイベント
    func toNewsList() {
        self.performSegue(withIdentifier: "toNews", sender: nil)
    }
    
    func toAboutCCM() {
        self.performSegue(withIdentifier: "toAboutCCM", sender: nil)
    }
    
    func toHowToUse() {
        self.performSegue(withIdentifier: "toHowToUse", sender: nil)
    }

    func refresh() {
        getTweet()

        self.refreshControl.endRefreshing()
    }
}

