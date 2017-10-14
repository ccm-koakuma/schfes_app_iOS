//
//  AppDelegate.swift
//  schfes_app_iOS
//
//  Created by 藤尾和裕 on 2017/06/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import TwitterKit
// 通知機能の実装
import UserNotifications
import NotificationCenter

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
    
    func cropImage(image :UIImage, w:Int, h:Int) ->UIImage
    {
        // リサイズ処理
        let origRef    = image.cgImage
        let origWidth  = Int(origRef!.width)
        let origHeight = Int(origRef!.height)
        var resizeWidth:Int = 0, resizeHeight:Int = 0
        
        if (origWidth < origHeight) {
            resizeWidth = w
            resizeHeight = origHeight * resizeWidth / origWidth
        } else {
            resizeHeight = h
            resizeWidth = origWidth * resizeHeight / origHeight
        }
        
        let resizeSize = CGSize.init(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
        
        UIGraphicsBeginImageContext(resizeSize)
        
        image.draw(in: CGRect.init(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 切り抜き処理
        
        let cropRect  = CGRect.init(x: CGFloat((resizeWidth - w) / 2), y: CGFloat((resizeHeight - h) / 2), width: CGFloat(w), height: CGFloat(h))
        let cropRef   = resizeImage!.cgImage!.cropping(to: cropRect)
        let cropImage = UIImage(cgImage: cropRef!)
        
        return cropImage
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ツイッターのAPI使う時に必要なおまじない
        Twitter.sharedInstance().start(withConsumerKey: "dBMG4VRZREdFdpTJl8gqD8gYA", consumerSecret: "7s1XATMuadE3UtZiWFgm1ogagxZWIlPkn6kOO6C3LrcRNHxATn")
        
        
        //-----------------------------------------------------------通知の設定-----------------------------------------------------------
        // 通知の許可を得るコード
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("通知許可")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                } else {
                    print("通知拒否")
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        var time = 30
        for i in 0..<3 {
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            var notificationTime = DateComponents()
            
            // トリガー設定(時間を指定したい場合これ)
            //        notificationTime.hour = 12
            //        notificationTime.minute = 0
            //        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            // 設定したタイミングを起点として1分後に通知したい場合
            
            

            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
            
            time += 5
            // 通知内容の設定
            content.title = "アプリ起動してから" + String(time) + "秒経ったお！！"
            content.body = "☓☓時□□分から◯◯で△△が開催されます！"
            content.sound = UNNotificationSound.default()
        
            // 通知スタイルを指定
            let notifiId: String = "uuid" + String(time)
            let request = UNNotificationRequest(identifier: notifiId, content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        // -----------------------------------------------------------タブバー、ナビバーの設定-----------------------------------------------------------
        // オレンジカラー作成
        let orangeColor = UIColor(red: 235/255.0, green: 97/255.0, blue: 0/255.0, alpha: 1)

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
        // -----------------------------------------------------------1ページ目になるViewController-----------------------------------------------------------
        let topVC = MainSB.instantiateViewController(withIdentifier: "TopVC") as UIViewController
        // 画像のインスタンス生成
        let topIcon = UIImage(named: "top_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let topSelectedIcon = UIImage(named: "top_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let topTabBarItem = UITabBarItem()
        // タグ設定
        topTabBarItem.tag = 1
        // 画像を設定
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
        
        
        //-----------------------------------------------------------2ページ目になるViewController-----------------------------------------------------------
        let scheduleVC = MainSB.instantiateViewController(withIdentifier: "ScheduleVC") as UIViewController
        
        // 画像のインスタンス生成
        let scheduleIcon = UIImage(named: "schedule_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let scheduleSelectedIcon = UIImage(named: "schedule_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let scheduleTabBarItem = UITabBarItem()
        // タグ設定
        scheduleTabBarItem.tag = 2
        // 画像を設定
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
        
        
        //-----------------------------------------------------------3ページ目になるViewController-----------------------------------------------------------
        let shopVC = MainSB.instantiateViewController(withIdentifier: "ShopVC") as UIViewController
        
        // 画像のインスタンス生成
        let shopIcon = UIImage(named: "shop_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let shopSelectedIcon = UIImage(named: "shop_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let shopTabBarItem = UITabBarItem()
        // タグ設定
        shopTabBarItem.tag = 3
        // 画像を設定
        shopTabBarItem.image = shopIcon
        shopTabBarItem.selectedImage = shopSelectedIcon
        // 画像の位置を少し下に
        shopTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        shopVC.tabBarItem = shopTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        shopVC.navigationItem.title = "模擬店一覧"
        // Navication Controllerを生成する.
        let shopNaviVC: UINavigationController = UINavigationController(rootViewController: shopVC)
        viewControllers.append(shopNaviVC)
        

        // -----------------------------------------------------------4ページ目になるViewController-----------------------------------------------------------
        let mapVC = MainSB.instantiateViewController(withIdentifier: "MapVC") as UIViewController
        
        // 画像のインスタンス生成
        let mapIcon = UIImage(named: "map_icon.png")?.ResizeUIImage(width: 45, height: 45)
        let mapSelectedIcon = UIImage(named: "map_selected_icon.png")?.ResizeUIImage(width: 45, height: 45).withRenderingMode(.alwaysOriginal)
        
        // タブバーに表示するアイテムの設定
        let mapTabBarItem = UITabBarItem()
        //タグ設定
        mapTabBarItem.tag = 4
        // 画像を設定
        mapTabBarItem.image = mapIcon
        mapTabBarItem.selectedImage = mapSelectedIcon
        // 画像の位置を少し下に
        mapTabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        mapVC.tabBarItem = mapTabBarItem
        // .titleでタイトル指定するとタブバーにタイトルが表示されてしまうため、.navigationItem.titleに文字列を代入している
        mapVC.navigationItem.title = "学内マップ"
        // Navication Controllerを生成する.
        let mapNaviVC: UINavigationController = UINavigationController(rootViewController: mapVC)
        viewControllers.append(mapNaviVC)
        

        // -----------------------------------------------------------TabBarControllerをセット-----------------------------------------------------------
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
        print("DidEnterbackGround")
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
    
    //上記のNotificatioを５秒後に受け取る関数
    //ポップアップ表示のタイミングで呼ばれる関数
    //（アプリがアクティブ、非アクテイブ、アプリ未起動,バックグラウンドでも呼ばれる）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    //ポップアップ押した後に呼ばれる関数(↑の関数が呼ばれた後に呼ばれる)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Alertダイアログでテスト表示
        let contentBody = response.notification.request.content.body
        let alert:UIAlertController = UIAlertController(title: "受け取りました", message: contentBody, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action:UIAlertAction!) -> Void in
            print("Alert押されました")
        }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        completionHandler()
    }


}

