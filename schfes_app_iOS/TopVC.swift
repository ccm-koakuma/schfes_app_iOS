//
//  TopVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import TwitterKit

class TopVC: UIViewController {
    
    private var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定ボタンの追加
        let button = UIBarButtonItem()
        button.image = UIImage(named: "images/setting_icon.png")?.ResizeUIImage(width: 35, height: 35)
        button.style = UIBarButtonItemStyle.plain
        button.action = #selector(self.TapMenu)
        button.target = self
        self.navigationItem.rightBarButtonItem = button
        
        
        
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        // Buttonを生成する.
        myButton = UIButton()
        
        // ボタンの設置座標とサイズを設定する.
        myButton.frame = CGRect(x: posX, y: posY + 100, width: bWidth, height: bHeight)
        
        // ボタンの背景色を設定.
        myButton.backgroundColor = UIColor.red
        
        // ボタンの枠を丸くする.
        myButton.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        myButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        myButton.setTitle("ニュースはこちら", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // ボタンにタグをつける.
        myButton.tag = 1
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickMyButton), for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view.addSubview(myButton)
        
        var myLabel: UILabel = UILabel(frame: CGRect(x: 0, y:0, width: 300, height: 500))
        
        myLabel.text = "ここはショップの詳細だお"
        
        myLabel.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(myLabel)
        
        
        
        if let session = Twitter.sharedInstance().sessionStore.session() {
            print(session.userID)
            var clientError: NSError?
            
            // タイムライン取得
            let apiClient = TWTRAPIClient(userID: session.userID)
            let request = apiClient.urlRequest(
                withMethod: "GET",
                url: "https://api.twitter.com/1.1/search/tweets.json?q=%23MHW&lang=ja&result_type=mixed&count=4",
                parameters: [
                    "user_id": session.userID,
                    "count": "10", // Intで10を渡すとエラーになる模様で、文字列にしてやる必要がある
                ],
                error: &clientError
            )
            
            apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let json = String(data: data, encoding: .utf8) {
                    print(json)
                    print("hogeeeee")
                }
            }
            
        } else {
            print("アカウントはありません")
        }
        
//        Twitter.sharedInstance().logIn { session, error in
//            guard let session = session else {
//                if let error = error {
//                    print("エラーが起きました => \(error.localizedDescription)")
//                }
//                return
//            }
//            print("@\(session.userName)でログインしました")
//        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     ボタンのイベント.
     */
    func onClickMyButton() {
        self.performSegue(withIdentifier: "toNews", sender: nil)
    }

    func TapMenu() {
        print("メニューがタップされました")
    }

}

