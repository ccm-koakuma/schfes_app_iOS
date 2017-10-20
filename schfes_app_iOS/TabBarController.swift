//
//  TabBarController.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/10/15.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // オレンジカラー作成
    let orangeColor = UIColor(red: 235/255.0, green: 97/255.0, blue: 0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タブバー選択時の色の指定
        UITabBar.appearance().tintColor = orangeColor
        
        // ナビバー部分の色の変更
        // これがないと色が薄くなってしまう
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = orangeColor

        // 戻るボタンや歯車アイコンの色変更
        UINavigationBar.appearance().tintColor = UIColor.white
        // タイトルの文字色変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        // main.storybordの変数
        let MainSB = UIStoryboard(name: "Main", bundle: nil)

        
        // -----------------------------------------------------------1ページ目になるViewController-----------------------------------------------------------
        let topVC = MainSB.instantiateViewController(withIdentifier: "TopVC")
        // 画像のインスタンス生成
        let size45 = CGSize(width: 45, height: 45)
        let topIcon = UIImage(named: "top_icon.png")?.ResizeUIImage(size: size45)
        let topSelectedIcon = UIImage(named: "top_selected_icon.png")?.ResizeUIImage(size: size45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let topTabBarItem = UITabBarItem()
        // タグ設定
        topTabBarItem.tag = 1
        // 画像を設定
        topTabBarItem.image = topIcon
        topTabBarItem.selectedImage = topSelectedIcon
        // 画像の位置を少し下に
        topTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        // TopVCにセット
        topVC.tabBarItem = topTabBarItem
        
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        topVC.navigationItem.title = "県大祭2017"
        
        // Navication Controllerを生成する.
        let topNaviVC: UINavigationController = UINavigationController(rootViewController: topVC)
        viewControllers.append(topNaviVC)
        
        
        //-----------------------------------------------------------2ページ目になるViewController-----------------------------------------------------------
        let scheduleVC = MainSB.instantiateViewController(withIdentifier: "ScheduleVC") as UIViewController
        
        // 画像のインスタンス生成
        let scheduleIcon = UIImage(named: "schedule_icon.png")?.ResizeUIImage(size: size45)
        let scheduleSelectedIcon = UIImage(named: "schedule_selected_icon.png")?.ResizeUIImage(size: size45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let scheduleTabBarItem = UITabBarItem()
        // タグ設定
        scheduleTabBarItem.tag = 2
        // 画像を設定
        scheduleTabBarItem.image = scheduleIcon
        scheduleTabBarItem.selectedImage = scheduleSelectedIcon
        // 画像の位置を少し下に
        scheduleTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        // ScheduleVCにセット
        scheduleVC.tabBarItem = scheduleTabBarItem
        
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        scheduleVC.navigationItem.title = "スケジュール"
        // Navication Controllerを生成する.
        let scheduleNaviVC: UINavigationController = UINavigationController(rootViewController: scheduleVC)
        viewControllers.append(scheduleNaviVC)
        
        
        //-----------------------------------------------------------3ページ目になるViewController-----------------------------------------------------------
        let shopVC = MainSB.instantiateViewController(withIdentifier: "ShopVC") as UIViewController
        
        // 画像のインスタンス生成
        let shopIcon = UIImage(named: "shop_icon.png")?.ResizeUIImage(size: size45)
        let shopSelectedIcon = UIImage(named: "shop_selected_icon.png")?.ResizeUIImage(size: size45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let shopTabBarItem = UITabBarItem()
        // タグ設定
        shopTabBarItem.tag = 3
        // 画像を設定
        shopTabBarItem.image = shopIcon
        shopTabBarItem.selectedImage = shopSelectedIcon
        // 画像の位置を少し下に
        shopTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        // ShopVCにセット
        shopVC.tabBarItem = shopTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        shopVC.navigationItem.title = "模擬店一覧"
        // Navication Controllerを生成する.
        let shopNaviVC: UINavigationController = UINavigationController(rootViewController: shopVC)
        viewControllers.append(shopNaviVC)
        
        
        // -----------------------------------------------------------4ページ目になるViewController-----------------------------------------------------------
        let mapVC = MainSB.instantiateViewController(withIdentifier: "MapVC") as UIViewController
        
        // 画像のインスタンス生成
        let mapIcon = UIImage(named: "map_icon.png")?.ResizeUIImage(size: size45)
        let mapSelectedIcon = UIImage(named: "map_selected_icon.png")?.ResizeUIImage(size: size45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let mapTabBarItem = UITabBarItem()
        //タグ設定
        mapTabBarItem.tag = 4
        // 画像を設定
        mapTabBarItem.image = mapIcon
        mapTabBarItem.selectedImage = mapSelectedIcon
        // 画像の位置を少し下に
        mapTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        // MapVCにセット
        mapVC.tabBarItem = mapTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        mapVC.navigationItem.title = "学内マップ"
        // Navication Controllerを生成する.
        let mapNaviVC: UINavigationController = UINavigationController(rootViewController: mapVC)
        viewControllers.append(mapNaviVC)

        self.setViewControllers(viewControllers, animated: true)
    }
}
