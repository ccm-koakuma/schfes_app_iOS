//
//  HowToUseVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

class HowToUseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        self.title = "このアプリの使い方"
        
        // 閉じるボタン配置
        let endButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.TapEnd))
        self.navigationItem.rightBarButtonItem = endButton
        
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        
        let myLabel: UILabel = UILabel(frame: CGRect(x: posX, y:posY, width: bWidth, height: bHeight))
        
        myLabel.text = "このアプリの使い方！"
        
        myLabel.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(myLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 閉じるボタンのアクション
    func TapEnd() {
        self.dismiss(animated: true, completion: nil)
    }
}


