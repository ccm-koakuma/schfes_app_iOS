//
//  TopVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

class TopVC: UIViewController {
    private var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        
        let myLabel: UILabel = UILabel(frame: CGRect(x: posX, y:posY, width: bWidth, height: bHeight))
        
        myLabel.text = "ここはトップだお"
        
        myLabel.textAlignment = NSTextAlignment.center
        
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
        myButton.setTitle("ボタン(通常)", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // ボタンにタグをつける.
        myButton.tag = 1
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickMyButton), for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view.addSubview(myButton)
        
        self.view.addSubview(myLabel)
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

}

