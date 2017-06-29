//
//  ViewController.swift
//  schfes_app_iOS
//
//  Created by 藤尾和裕 on 2017/06/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

//    削除予定
//    func loadJson(_ fileName : String) -> JSON?{
//        let path = Bundle.main.path(forResource: fileName, ofType: "json")
//        do{
//            //https://www.hackingwithswift.com/example-code/strings/how-to-load-a-string-from-a-file-in-your-bundle
//            let jsonStr = try String(contentsOfFile: path!)
//            let json =  JSON.parse(jsonStr)
//            return json
//        } catch{
//            return "hoge"
//        }
//    }
    
        func loadJson(_ fileName : String) -> JSON?{
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json"){
                do{
                    let jsonStr = try String(contentsOf: url)
                    let json =  JSON.parse(jsonStr)
                    return json
                } catch{
                    
                    return nil
                }
            }else{
                return nil
            }
        }
    
//    　削除予定
//    func readJson() {
//        do {
//            if let file = Bundle.main.url(forResource: "timetable", withExtension: "json") {
//                let data = try Data(contentsOf: file)
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let object = json as? [String: Any] {
//                    // json is a dictionary
//                    print(object)
//                } else if let object = json as? [Any] {
//                    // json is an array
//                    print(object)
//                } else {
//                    print("JSON is invalid")
//                }
//            } else {
//                print("no file")
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }

    
    func getFeed(sender: AnyObject){
        let feed = loadJson("feed")
        print(feed!)
    }
    
    func getTimeTable(sender: AnyObject){
        let timeTable = loadJson("timetable")
        print(timeTable!)
    }
    
    func getStall(sender: AnyObject){
        let stall = loadJson("stall")
        print("location : " + String(describing: stall![0]["location"]))
    }
    
    
//    削除予定
//    func StartButton(sender: AnyObject){
//        let toJSON: JSON = ["name": "Jack", "age": 25]
//        print(toJSON)
//        
//        let jsonString = "{\"あああ¥\": 25}"
//        
//        let dataFromString = jsonString.data(using: String.Encoding.utf8)
//        let json = JSON(data: dataFromString!)
//        print(json["あああ"])
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getFeedButton: UIButton = UIButton()
        getFeedButton.frame = CGRect(x:0, y:0, width: 100, height: 50)
        getFeedButton.backgroundColor = UIColor.gray
        getFeedButton.layer.masksToBounds = true
        getFeedButton.layer.cornerRadius = 10.0
        getFeedButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:200)
        getFeedButton.setTitle("GetFeed", for: .normal)
        getFeedButton.addTarget(self, action: #selector(getFeed(sender:)), for: .touchUpInside)
        
        let getTimeTableButton: UIButton = UIButton()
        getTimeTableButton.frame = CGRect(x:0, y:0, width: 100, height: 50)
        getTimeTableButton.backgroundColor = UIColor.gray
        getTimeTableButton.layer.masksToBounds = true
        getTimeTableButton.layer.cornerRadius = 10.0
        getTimeTableButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:350)
        getTimeTableButton.setTitle("GetTimeTable", for: .normal)
        getTimeTableButton.addTarget(self, action: #selector(getTimeTable(sender:)), for: .touchUpInside)
        
        let getStallButton: UIButton = UIButton()
        getStallButton.frame = CGRect(x:0, y:0, width: 100, height: 50)
        getStallButton.backgroundColor = UIColor.gray
        getStallButton.layer.masksToBounds = true
        getStallButton.layer.cornerRadius = 10.0
        getStallButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:500)
        getStallButton.setTitle("GetStall", for: .normal)
        getStallButton.addTarget(self, action: #selector(getStall(sender:)), for: .touchUpInside)
        
        
        self.view.backgroundColor = UIColor.cyan
        
        self.view.addSubview(getFeedButton)
        self.view.addSubview(getTimeTableButton)
        self.view.addSubview(getStallButton)
        
        
//        削除予定
//        if let path: String = Bundle.main.path(forResource: "test", ofType: "txt") {
//            
//            do {
//                // ファイルの内容を取得する
//                let content = try String(contentsOfFile: path)
//                print("content: \(content)")
//                
//            } catch  {
//                print("ファイルの内容取得時に失敗")
//            }
//            
//            
//        }else {
//            print("指定されたファイルが見つかりません")
//        }
        
//        readJson()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

