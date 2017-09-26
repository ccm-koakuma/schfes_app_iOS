//
//  AppDelegate.swift
//  schfes_app_iOS
//
//  Created by 藤尾和裕 on 2017/06/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import TwitterKit

extension UIImage{
    // Resizeするクラスメソッド.
    func ResizeUIImage(width : CGFloat, height : CGFloat)-> UIImage!{
        // 指定された画像の大きさのコンテキストを用意.
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // コンテキストに自身に設定された画像を描画する.
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        // コンテキストからUIImageを作る.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // コンテキストを閉じる.
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Twitter.sharedInstance().start(withConsumerKey: "dBMG4VRZREdFdpTJl8gqD8gYA", consumerSecret: "7s1XATMuadE3UtZiWFgm1ogagxZWIlPkn6kOO6C3LrcRNHxATn")
        
        let red = 235
        let green = 97
        let blue = 0
        
        let orangeColor = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        // タブバー選択時の色の指定
        UITabBar.appearance().tintColor = orangeColor
        // ナビバー部分の色の変更
        UINavigationBar.appearance().barTintColor = orangeColor
        // 戻るボタンや歯車アイコンの色変更
        UINavigationBar.appearance().tintColor = UIColor.white
        // タイトルの文字色変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        // 1ページ目になるViewController
        let topVC = MainSB.instantiateViewController(withIdentifier: "TopVC") as UIViewController
        let topIcon = UIImage(named: "images/top_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let topSelectedIcon = UIImage(named: "images/top_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let topTabBarItem = UITabBarItem()
        topTabBarItem.tag = 1
        topTabBarItem.image = topIcon
        topTabBarItem.selectedImage = topSelectedIcon
        // 画像の位置を少し下に
        topTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
    
        topVC.tabBarItem = topTabBarItem
        
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        topVC.navigationItem.title = "県大祭2017"
        
        // Navication Controllerを生成する.
        let topNaviVC: UINavigationController = UINavigationController(rootViewController: topVC)
        viewControllers.append(topNaviVC)
        
        
        //--------------------------------------------------------------------------------------------------
        // 2ページ目になるViewController
        let scheduleVC = MainSB.instantiateViewController(withIdentifier: "ScheduleVC") as UIViewController
        
        let scheduleIcon = UIImage(named: "images/schedule_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let scheduleSelectedIcon = UIImage(named: "images/schedule_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let scheduleTabBarItem = UITabBarItem()
        scheduleTabBarItem.tag = 2
        scheduleTabBarItem.image = scheduleIcon
        scheduleTabBarItem.selectedImage = scheduleSelectedIcon
        // 画像の位置を少し下に
        scheduleTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        scheduleVC.tabBarItem = scheduleTabBarItem

        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        scheduleVC.navigationItem.title = "スケジュール"
        // Navication Controllerを生成する.
        let scheduleNaviVC: UINavigationController = UINavigationController(rootViewController: scheduleVC)
        viewControllers.append(scheduleNaviVC)
        
        
        //--------------------------------------------------------------------------------------------------
        // 3ページ目になるViewController
        let shopVC = MainSB.instantiateViewController(withIdentifier: "ShopVC") as UIViewController
        
        let shopIcon = UIImage(named: "images/shop_icon.png")?.ResizeUIImage(width: 45, height: 45)
//        let shopSelectedIcon = UIImage(named: "images/shop_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let shopTabBarItem = UITabBarItem()
        shopTabBarItem.tag = 3
        shopTabBarItem.image = shopIcon
        // 画像の位置を少し下に
        shopTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        shopVC.tabBarItem = shopTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        shopVC.navigationItem.title = "模擬店一覧"
        // Navication Controllerを生成する.
        let shopNaviVC: UINavigationController = UINavigationController(rootViewController: shopVC)
        viewControllers.append(shopNaviVC)
        
        
        //--------------------------------------------------------------------------------------------------
        // 4ページ目になるViewController
        let mapVC = MainSB.instantiateViewController(withIdentifier: "MapVC") as UIViewController
        
        let mapIcon = UIImage(named: "images/map_icon.png")?.ResizeUIImage(width: 45, height: 45)
//        let mapSelectedIcon = UIImage(named: "images/map_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let mapTabBarItem = UITabBarItem()
        mapTabBarItem.tag = 4
        mapTabBarItem.image = mapIcon
        // 画像の位置を少し下に
        mapTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        mapVC.tabBarItem = mapTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        mapVC.navigationItem.title = "学内マップ"
        // Navication Controllerを生成する.
        let mapNaviVC: UINavigationController = UINavigationController(rootViewController: mapVC)
        viewControllers.append(mapNaviVC)
        
        
        //--------------------------------------------------------------------------------------------------
        // ViewControllerをセット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // rootViewControllerをUITabBarControllerにする
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Twitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

