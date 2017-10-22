//
//  ScheduleVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import PagingMenuController

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    private let allScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllScheduleVC")
    private let favoScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoScheduleVC")
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [allScheduleVC, favoScheduleVC]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        var focusMode: MenuFocusMode {
            // ここ後で色変えなきゃね
            return .underline(height: 3, color: UIColor.orange, horizontalPadding: 0, verticalPadding: 0)
        }

    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "ALL"))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Favorite"))
        }
    }
}

class RootScheduleVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += 64
        pagingMenuController.view.frame.size.height -= 64
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
    }
}

