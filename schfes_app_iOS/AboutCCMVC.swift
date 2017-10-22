//
//  AboutCCM.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

class AboutCCMVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CCMとは"
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        // 閉じるボタン配置
        let endButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.TapEnd))
        self.navigationItem.rightBarButtonItem = endButton
        
        // -----------------------------------CCMとは？ラベルの作成-----------------------------------
        let titleLabel1Y: CGFloat = 65
        let titleLabel1: UILabel = UILabel(frame: CGRect(x: 10, y:titleLabel1Y, width: self.view.frame.width, height: 40))
        titleLabel1.text = "CCM(Core Creative Manager)とは？"
        titleLabel1.textAlignment = NSTextAlignment.left
        titleLabel1.font = UIFont.systemFont(ofSize: 20)
        //単語の途中で改行されないようにする
        
        
        titleLabel1.numberOfLines = 0
        self.view.addSubview(titleLabel1)
        
        let contentLabel1Y: CGFloat = 110

        let contentLabel1: UILabel = UILabel(frame: CGRect(x: 20, y: contentLabel1Y, width: self.view.frame.width-60, height: 100))
        contentLabel1.text = " Core Creative ManagerはWebやアプリの開発を通して富山県立大学をより良い大学にすることを目的に活動している学生団体です。工学部らしい「工学心」を持った大学貢献を行っています。"
        contentLabel1.numberOfLines = 0
        contentLabel1.lineBreakMode = .byWordWrapping
        contentLabel1.sizeToFit()
        
        self.view.addSubview(contentLabel1)
        
        // -----------------------------------CCMの活動ラベルの作成-----------------------------------
        let titleLabel2Y: CGFloat = 230
        let titleLabel2: UILabel = UILabel(frame: CGRect(x: 10, y:titleLabel2Y, width: self.view.frame.width, height: 40))
        titleLabel2.text = "CCMの活動内容"
        titleLabel2.textAlignment = NSTextAlignment.left
        titleLabel2.font = UIFont.systemFont(ofSize: 20)
        //単語の途中で改行されないようにする
        
        
        titleLabel2.numberOfLines = 0
        self.view.addSubview(titleLabel2)
        
        let contentLabel2Y: CGFloat = 270
        
        let contentLabel2: UILabel = UILabel(frame: CGRect(x: 15, y: contentLabel2Y, width: self.view.frame.width-30, height: 100))
        contentLabel2.text = " ・Webサイト「TPU marker」の開発、運営\n ・キャリアセンターのWeb開発\n ・掲示板の電子化\n 学内アンケートのWeb化\n ・学祭アプリ開発"
        contentLabel2.numberOfLines = 0
        contentLabel2.lineBreakMode = .byWordWrapping
        contentLabel2.sizeToFit()
        
        self.view.addSubview(contentLabel2)
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

