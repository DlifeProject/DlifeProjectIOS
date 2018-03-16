//
//  TestViewController.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/9.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import Alamofire



// result :server傳回來的結果 回來是json就轉成字典
typealias DoneHandler = (_ error:Error?, _ result:[String:Any]?) -> Void
typealias DownloadDoneHandler = (_ error:Error?, _ result:Data?) -> Void

class Common {
    
    static let shared = Common()
    
    private init() {
        
    }
    static let BASEURL="http://114.34.110.248:7070/Dlife/"
    static let PHOTO_URL="photo"
    static let TEST_URL="test"
    static let DIARY_URL="diary"
    static let LOGIN_URL="login"
    static let SUMMARY_URL="summary"
    static let MAPAPI_URL="mapapi"
    static let FRIEND_URL="friend"
    
    
    
    // MARK: 上傳下載文字Dictionary
    func text(jsonDictionary: Dictionary<String, Any>, doneHandler:@escaping DoneHandler) {
        
        doPost(urlString: "http://114.34.110.248:7070/Dlife/test", parameters: jsonDictionary, doneHandler: doneHandler)
    }
    
    
    // MARK: doPost
    func doPost(urlString:String, parameters:[String:Any], doneHandler:@escaping DoneHandler) {

        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, doneHandler: doneHandler)
            
        }
    }
    
    // MARK: handleResponse
    func handleResponse(_ response:DataResponse<Any>, doneHandler:DoneHandler) {
        switch response.result {
        case.success(let json):
            NSLog("doPost success with result: \(json)")
            // 因為這邊 Alamofire 都處理過 不太可能為 nil 所以幾乎用!
            let resultJSON = json as! [String:Any]
            
            print(resultJSON)
            
            //let serverResult = resultJSON.first?.value
            let serverResult = resultJSON["memberProfile"] as! String
            print(serverResult)
            
            // 把json變成Data型別 讓他可以去序列化解包json
            let data = serverResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            print(data)
            // 接下來把剛剛那個data 把裡面每個東西 轉成key and value
            // 類似android我們在解一個json object
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(json)
                
                // 成功取出可以把結果給 doneHandler東西了 [String: Any]
                doneHandler(nil, json)
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            

        case.failure(let error):
            NSLog("doPost fail with error: \(error)")
            doneHandler(error, nil)
        }
    }
  
    
    // MARK: 生成URL
    static func fileURL(fileKey: String) -> URL {
        //生成路經
        //準備FileManager
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        //準備存檔檔名
        let  fileURL = documentURL.appendingPathComponent("\(fileKey)").appendingPathExtension("plist")
        
        return fileURL
    }
    
    // MARK: plist儲存
    static func plistSave(fileURL: URL, dictionary: Dictionary<String, Any>) {
        
        // 把Dictionary轉Data
        let dataExample = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        // 把路徑用出來
        print("存檔於: " + fileURL.absoluteString)
        // 將編碼後的資料儲存到路徑
        try? dataExample.write(to: fileURL, options: .noFileProtection)
        
    }
    
    
    // MARK: plist讀取
    static func plistLoad(fileURL: URL) -> Dictionary<String, Any> {
        
        // 從URL拿到Data
        let retrievedData = try? Data(contentsOf: fileURL)
        // 把Data轉成Dictionary
        let json = try! JSONSerialization.jsonObject(with: retrievedData!, options: .mutableContainers) as! Dictionary<String, Any>
        
        return json
    }
    
    // MARK: 製作基本Dictionary
    static func DictionaryMake(action: String, account: String, password: String) -> Dictionary<String, Any> {
        var dictionary: Dictionary<String, Any> = ["0": 0]
        dictionary.updateValue(action, forKey: "action")
        dictionary.updateValue(account, forKey: "account")
        dictionary.updateValue(password, forKey: "password")
        dictionary.removeValue(forKey: "0")
        
        return dictionary
        
    }
    
}

