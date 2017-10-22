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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        // タイトル設定
        self.title = "ビンゴの番号"
    
        // ボタンのサイズを定義.
        let bWidth: CGFloat = self.view.frame.width
        let bHeight: CGFloat = self.view.frame.height
        
        
        let bingoLabel: UILabel = UILabel(frame: CGRect(x: 0, y:0, width: bWidth, height: bHeight))
        
        bingoLabel.text = ""
        
        
        // データを取得
        let listUrl = "http://150.95.142.204/app2017/bingo";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? "")
            json.forEach{(arg) in
                
                let (_, data) = arg
                if data != nil{
                    bingoLabel.text = bingoLabel.text! + String(describing: data) + " "
                }
            }
        }
        
        
        bingoLabel.textAlignment = NSTextAlignment.left
        bingoLabel.numberOfLines = 0
        bingoLabel.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(bingoLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

