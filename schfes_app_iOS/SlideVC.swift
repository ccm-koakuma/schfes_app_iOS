//
//  SlideVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/15.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideVC: SlideMenuController {
    
    static let menuWidth: CGFloat = 250
    
    override func awakeFromNib() {
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: TabBarController = TabBarController()
        let settingMenuVC = MainSB.instantiateViewController(withIdentifier: "SettingMenuVC")
//        let settingMenuNaviVC: UINavigationController = UINavigationController(rootViewController: settingMenuVC)
        
        //ライブラリ特有のプロパティにセット
        mainViewController = tabBarController
        rightViewController = settingMenuVC
        
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.rightViewWidth = SlideVC.menuWidth
        SlideMenuOptions.rightPanFromBezel = false
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
