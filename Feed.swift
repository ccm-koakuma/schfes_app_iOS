//
//  Feed.swift
//  schfes_app_iOS
//
//  Created by FGO on 2017/07/17.
//  Copyright © 2017年 藤尾和裕. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Plans{
    
    enum CustomError: Error{
        case unexpectedString
    }
    
    var planName: String!
    
    let urls:Dictionary! = [
        "feed" : "http://ytrw3xix.0g0.jp/app2017/feed",
        "stall" : "http://ytrw3xix.0g0.jp/app2017/stall",
        "timetable" : "http://ytrw3xix.0g0.jp/app2017/timetable",
    ]
    
    let Cache = UserDefaults.standard
    
    var ids:[Int] = []
    var sections:[String] = []
    var targets:[String] = []
    var contents:[String] = []
    var times:[String] = []
    var timeReqs:[String] = []
    var spots:[String] = []
    var layoutStyles:[String] = []
    var imgUrls:[String] = []
    var places:[String] = []
    var floors:[String] = []
    var reserveInfos:[String] = []
    
    var delegate: HttpDelegate?
    
    init (planName: String){
        self.planName = planName
    }
    
    // 初期化時に指定された企画名の企画を取得
    func HttpGet() {
        Alamofire.request(urls[planName]!)
            .responseJSON { response in
                guard let object = response.result.value else {
                    print("ErrorHTTP")
                    //bthrow CustomError.UnexpectedString
                    //                    throw MyError.UnexpectedError
                    return
                }
                
                let json = JSON(object)
                //print(json)
                
                json.forEach { (_, json) in
                    json.forEach { (_, json) in
                        if json["id"].int != nil {
                            self.ids.append(json["id"].int!)
                            print(json["id"].int!)}
                        if json["name"].string != nil {
                            self.sections.append(json["name"].string!) }
                        if json["target"].string != nil {
                            self.targets.append(json["target"].string!) }
                        if json["contents"].string != nil {
                            self.contents.append(json["contents"].string!) }
                        if json["time"].string != nil {
                            self.times.append(json["time"].string!) }
                        if json["timeReq"].string != nil {
                            self.timeReqs.append(json["timeReq"].string!) }
                        if json["spot"]["place"].string != nil && json["spot"]["floor"].string != nil && json["spot"]["room"].string != nil {
                            self.spots.append("\(json["spot"]["place"]) \(json["spot"]["floor"]) \(json["spot"]["room"])") }
                        if json["layoutStyle"].string != nil {
                            self.layoutStyles.append(json["layoutStyle"].string!) }
                        if json["imgUrl"].string != nil {
                            self.imgUrls.append(json["imgUrl"].string!) }
                        if json["spot"]["place"].string != nil {
                            self.places.append(json["spot"]["place"].string!) }
                        if json["spot"]["floor"].string != nil {
                            self.floors.append(json["spot"]["floor"].string!) }
                        if json["reserveInfo"].string != nil {
                            self.reserveInfos.append(json["reserveInfo"].string!) }
                    }
                }
                self.delegate?.didDownloadData()
        }
    }
    
    // お気にいりされているものだけ取得
    func HttpGetWithOnlyFavoritePlans(){
        Alamofire.request(urls[planName]!)
            .responseJSON { response in
                guard let object = response.result.value else {
                    print("ErrorHTTP")
                    return
                }
                
                let json = JSON(object)
                //print(json)
                
                json.forEach { (_, json) in
                    json.forEach { (_, json) in
                        // いいねボタンが押されている企画だけ抜粋している
                        if(self.Cache.object(forKey: String(json["id"].int!)) as! Bool){
                            if json["id"].int != nil {
                                self.ids.append(json["id"].int!)
                                print(json["id"].int!)}
                            if json["name"].string != nil {
                                self.sections.append(json["name"].string!) }
                            if json["target"].string != nil {
                                self.targets.append(json["target"].string!) }
                            if json["contents"].string != nil {
                                self.contents.append(json["contents"].string!) }
                            if json["time"].string != nil {
                                self.times.append(json["time"].string!) }
                            if json["timeReq"].string != nil {
                                self.timeReqs.append(json["timeReq"].string!) }
                            if json["spot"]["place"].string != nil && json["spot"]["floor"].string != nil && json["spot"]["room"].string != nil {
                                self.spots.append("\(json["spot"]["place"]) \(json["spot"]["floor"]) \(json["spot"]["room"])") }
                            if json["layoutStyle"].string != nil {
                                self.layoutStyles.append(json["layoutStyle"].string!) }
                            if json["imgUrl"].string != nil {
                                self.imgUrls.append(json["imgUrl"].string!) }
                            if json["spot"]["place"].string != nil {
                                self.places.append(json["spot"]["place"].string!) }
                            if json["spot"]["floor"].string != nil {
                                self.floors.append(json["spot"]["floor"].string!) }
                            if json["reserveInfo"].string != nil {
                                self.reserveInfos.append(json["reserveInfo"].string!) }
                        }
                    }
                }
                self.delegate?.didDownloadData()
        }
    }
}
