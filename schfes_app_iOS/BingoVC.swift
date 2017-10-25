//
//  BingoVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/22.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class BingoVC: UIViewController {

    var items: [JSON] = []
    
    let bingoLabel = UILabel()
    
    let scrollView = UIScrollView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        // タイトル設定
        self.title = "ビンゴの番号"
    
        
        scrollView.backgroundColor = UIColor.clear
        

        // 中身の大きさを設定
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-100)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // スクロールの跳ね返り
        scrollView.bounces = true
        
        // スクロールバーの見た目と余白
        scrollView.indicatorStyle = .default
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        // Delegate を設定
        scrollView.delegate = self as? UIScrollViewDelegate
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        
        self.view.addSubview(scrollView)
        
        // AutoLayoutの設定
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        // サイズを定義.
        let bWidth: CGFloat = self.view.frame.width
        let bHeight: CGFloat = self.view.frame.height
        
        bingoLabel.frame = CGRect(x: 0, y:0, width: bWidth, height: bHeight)
        
        bingoLabel.text = ""
        
        
        getBingoNum()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBingoNum() {
        // URLキャッシュを削除
        URLCache.shared.removeAllCachedResponses()
        // データを取得
        bingoLabel.text = ""
        let listUrl = "http://150.95.142.204/app2017/bingo";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(arg) in
                
                let (_, data) = arg
                if data != nil{
                    self.bingoLabel.text = self.bingoLabel.text! + String(describing: data) + " "
                }
            }
        }
        
        
        bingoLabel.textAlignment = NSTextAlignment.left
        bingoLabel.numberOfLines = 0
        bingoLabel.lineBreakMode = .byWordWrapping
        
        self.scrollView.addSubview(bingoLabel)
    }
    
    func refresh() {
        self.getBingoNum()
        self.refreshControl.endRefreshing()
    }
}

