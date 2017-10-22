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
        
        // -----------------------------------CCMとは？ラベルの作成-----------------------------------
        let titleLabel1Y: CGFloat = 65
        let titleLabel1: UILabel = UILabel(frame: CGRect(x: 10, y:titleLabel1Y, width: self.view.frame.width, height: 40))
        titleLabel1.text = "このアプリの使い方！"
        titleLabel1.textAlignment = NSTextAlignment.left
        titleLabel1.font = UIFont.systemFont(ofSize: 20)
        
        titleLabel1.numberOfLines = 0
        self.view.addSubview(titleLabel1)
        
        let contentLabel1Y: CGFloat = 110
        
        let contentLabel1: UILabel = UILabel(frame: CGRect(x: 30, y: contentLabel1Y, width: self.view.frame.width-60, height: 100))
        contentLabel1.text = "◆学祭に関するニュース\n　県大祭の情報を日々発信するサイトTPUMarkerと連動して県大祭に関するニュースが閲覧可能！\n\n◆みんなの反応\n　Twitterでのみんなの反応をリアルタイムに見たり、自分でツイートしたりして皆で楽しさを共有しよう！\n\n◆イベントをお気に入り機能\n　気になるイベントをお気に入り登録することで事前に通知してくれる！\n\n◆模擬店情報\n　出店されている各模擬店のメニュー等を知ることができる！"
        contentLabel1.numberOfLines = 0
        contentLabel1.lineBreakMode = .byWordWrapping
        contentLabel1.sizeToFit()
        
        self.view.addSubview(contentLabel1)
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


