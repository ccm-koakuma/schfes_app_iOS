//
//  StallView.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/08/28.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    let imageStrs: [String] = ["Bloody Moon（天文部）.png", "あげぱんまん（ひまわりサークル）.png", "アメリカンドック売りのハンジ（学生会）.png", "かすていらhirano（平野ゼミ）.png", "ジンギスカン屋（卓球部）.png", "そばあちゃん（水土里）.png", "テクニカルクッキングクラブ（TCC）.png", "パラダイス食堂（スキー部）.png", "バレー部の豚汁屋さん（バレーボール部）.png", "ピロティクルー（スケボーサークル）.png", "ヒロポン喫茶（TIP）.png", "ポテトとちゃんこと俺（COCOS）.png", "やきそば（アイスホッケー部）.png", "やきゅうどん（軟式野球部）.png", "ワッフルショップFLAT（FLAT）.png", "俺のフランクフルト（硬式テニス部）.png", "健康店（FLAT）.png", "手羽民（バド部）.png"]
    
    var imageViews: [UIImageView] = []
    
    let shopTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for imageStr in imageStrs {
            let image = UIImage(named: imageStr)
            let imageView = UIImageView(image: image)
            imageViews.append(imageView)
        }
        
        // これがないと画面全体が下にずれてしまう
        extendedLayoutIncludesOpaqueBars = true
        
        // TableViewの設定
        self.shopTableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.shopTableView.delegate = self
        self.shopTableView.dataSource = self
        
        
        self.shopTableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(self.shopTableView)
        
//        // データを取得
//        let listUrl = "http://150.95.142.204/app2017/stall";
//        Alamofire.request(listUrl).responseJSON{ response in
//            let json = JSON(response.result.value ?? "")
//            json.forEach{(_, data) in
//                print(data)
//                self.items.append(data)
//
//            }
//            self.shopTableView.reloadData()
//        }
    }
    
    // セルの高さの設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width*640/2150
    }
    
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        cell.backgroundView = imageViews[indexPath.row]
        // cellの背景を透過
        cell.backgroundColor = UIColor.clear
        // cell内のcontentViewの背景を透過
        cell.contentView.backgroundColor = UIColor.clear
        // 選択できないようにする
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageStrs.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
