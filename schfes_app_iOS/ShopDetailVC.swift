//
//  ShopDetailVC.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/31.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopDetailVC: UIViewController {
    
    var item: JSON = []
    
    var shopImage: UIImage = UIImage()
    let shopImageView: UIImageView = UIImageView()
    
    
    let shopName: UILabel = UILabel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        self.title = item["slname"].string
        
        // 画像の座標、大きさの指定
        let imageWidth: CGFloat = UIScreen.main.bounds.width
        let imageHeight: CGFloat = imageWidth*640/2100
        let imageX: CGFloat = UIScreen.main.bounds.width/2-imageWidth/2
        let imageY: CGFloat = UIScreen.main.bounds.height*3/10-imageHeight/2
        
        let imageSize: CGSize = CGSize(width: imageWidth, height: imageHeight)
        
        shopImage = (UIImage(named: "手羽民（バド部）.png")?.ResizeUIImage(size: imageSize))!
        
        shopImageView.image = shopImage
        shopImageView.frame = CGRect(x: imageX, y: imageHeight/2, width: imageWidth, height: imageHeight)
        
        self.view.addSubview(shopImageView)
        
        let shopNameX: CGFloat = 0
        let shopNameY: CGFloat = imageY+imageWidth
        let shopNameWidth: CGFloat = UIScreen.main.bounds.height
        let shopNameHeight: CGFloat = 200
        
        shopName.text = item["slname"].string
        shopName.frame = CGRect(x: shopNameX, y: shopNameY, width: shopNameWidth, height: shopNameHeight)
        shopName.font = UIFont.systemFont(ofSize: 15.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

