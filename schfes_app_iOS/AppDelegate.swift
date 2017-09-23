//
//  AppDelegate.swift
//  schfes_app_iOS
//
//  Created by 藤尾和裕 on 2017/06/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        // 1ページ目になるViewController
        let topVC = MainSB.instantiateViewController(withIdentifier: "TopVC") as UIViewController
        topVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        topVC.title = "Top"
        // Navication Controllerを生成する.
        let topNaviVC: UINavigationController = UINavigationController(rootViewController: topVC)
        viewControllers.append(topNaviVC)
        
        // 2ページ目になるViewController
        let scheduleVC = MainSB.instantiateViewController(withIdentifier: "RootScheduleVC") as UIViewController
        scheduleVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        scheduleVC.title = "Schedule"
        // Navication Controllerを生成する.
        let scheduleNaviVC: UINavigationController = UINavigationController(rootViewController: scheduleVC)
        viewControllers.append(scheduleNaviVC)
        
        // 3ページ目になるViewController
        let shopVC = MainSB.instantiateViewController(withIdentifier: "ShopVC") as UIViewController
        shopVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 3)
        shopVC.title = "Shops"
        // Navication Controllerを生成する.
        let shopNaviVC: UINavigationController = UINavigationController(rootViewController: shopVC)
        viewControllers.append(shopNaviVC)
        
        // 4ページ目になるViewController
        let mapVC = MainSB.instantiateViewController(withIdentifier: "MapVC") as UIViewController
        mapVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 4)
        mapVC.title = "Map"
        // Navication Controllerを生成する.
        let mapNaviVC: UINavigationController = UINavigationController(rootViewController: mapVC)
        viewControllers.append(mapNaviVC)
        
        // ViewControllerをセット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // rootViewControllerをUITabBarControllerにする
        window = UIWindow()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
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

