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
typealias DoneHandler1 = (_ error:Error?, _ result:[String:Any]?) -> Void
typealias DoneHandler2 = (_ error:Error?, _ result:[[String:Any]]?) -> Void
typealias UpdateLandmarkDoneHandler = (_ error:Error?, _ result:String?) -> Void
//下方兩個圖片用
typealias DownloadDoneHandler = (_ error:Error?, _ result: Data?) -> Void
typealias UpdateDoneHandler = (_ error:Error?, _ result:Int?) -> Void



class Common {
    
    static let shared = Common()
    private init() {
    }
    static let BASEURL="http://192.168.196.171:8080/Dlife/"
    static let PHOTO_URL="photo"
    static let TEST_URL="test"
    static let DIARY_URL="diary"
    static let LOGIN_URL="login"
    static let SUMMARY_URL="summary"
    static let MAPAPI_URL="mapapi"
    static let FRIEND_URL="friend"
    //static var UUID:String!
    
    static let PREFFERENCES_USER_ACCOUNT = "userAccount";
    static let PREFFERENCES_USER_PASSWORD = "userPassword";
    static let PREFFERENCES_UUID = "userUUID";
    static let PREFFERENCES_NICKNAME = "nickname";
    static let PREFFERENCES_USER_LAST_LOGIN_DATE = "loginDate";
    static let PREFFERENCES_BIRTHDAY = "birthday";
    
    
    
    // MARK: 上傳下載文字Dictionary
    func text(api: String, jsonDictionary: Dictionary<String, Any>, doneHandler:@escaping DoneHandler1) {
        
        let action = jsonDictionary["action"] as! String
        
        doPost(action: action, urlString: "http://192.168.196.135:8080/Dlife/" + api, parameters: jsonDictionary, doneHandler: doneHandler)
    }
    
    // MARK: 上傳下載文字Dictionary(Dictionary包Dictionary型)
    func text(api: String, jsonDictionary: Dictionary<String, Any>, jsonRow: Int , doneHandler:@escaping DoneHandler2) {
        
        let action = jsonDictionary["action"] as! String
        
        doPost(action: action, urlString: "http://192.168.196.135:8080/Dlife/" + api, parameters: jsonDictionary, jsonRow: jsonRow, doneHandler: doneHandler)
    }
    // MARK: - 上傳日記用
    func textUpate(api: String, jsonDictionary: Dictionary<String, Any>, doneHandler:@escaping UpdateDoneHandler) {
    
        doPost(urlString: "http://192.168.196.135:8080/Dlife/" + api, parameters: jsonDictionary, doneHandler: doneHandler)
    }
    // MARK: - 上傳地標用
    func textUpateLandmark(api: String, jsonDictionary: Dictionary<String, Any>, doneHandler:@escaping UpdateLandmarkDoneHandler) {
        
        doPost(urlString: "http://192.168.196.135:8080/Dlife/" + api, parameters: jsonDictionary, doneHandler: doneHandler)
    }
    
    
    
    // MARK: doPost
    func doPost(action: String, urlString:String, parameters:[String:Any], doneHandler:@escaping DoneHandler1) {
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, action: action, doneHandler: doneHandler)
        
            
        }
      
    }
    
    // MARK: doPost(Dictionary包Dictionary型)
    func doPost(action: String, urlString:String, parameters:[String:Any], jsonRow: Int, doneHandler:@escaping DoneHandler2) {
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, action: action, jsonRow: jsonRow, doneHandler: doneHandler)
          
        }
    }
     // MARK: - 上傳日記用
    func doPost(urlString:String, parameters:[String:Any], doneHandler:@escaping UpdateDoneHandler) {
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, action: action, doneHandler: doneHandler)
            
        }
    }
    
    // MARK: doPost(Dictionary包Dictionary型)
    func doPost(action: String, urlString:String, parameters:[String:Any], jsonRow: Int, doneHandler:@escaping DoneHandler2) {
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, action: action, jsonRow: jsonRow, doneHandler: doneHandler)
            
            
        }
        
    }
    // MARK: - 上傳地標用
    func doPost(urlString:String, parameters:[String:Any], doneHandler:@escaping UpdateLandmarkDoneHandler) {
        
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            self.handleResponse(response, doneHandler: doneHandler)
            
            
        }
        
    }
    
    // MARK: handleResponse
    func handleResponse(_ response:DataResponse<Any>, action: String,  doneHandler:DoneHandler1) {
        switch response.result {
        case .success(let json):
            print("doPOST success with result: \(json)")   //json String
            
            let resultJSON1 = json as! [String:Any]
            print("1: \n \(resultJSON1)")
            let resultJSON2 = resultJSON1[action]! as! String
            print("2: \n \(resultJSON2)")
            
            let data = resultJSON2.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print("json: \n \(json)")
                
                doneHandler(nil, json)
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                doneHandler(error, nil)
                
            }
            
        case .failure(let error):
            NSLog("doPOST fail with error: \(error)")
            doneHandler(error, nil)
        }
        
    }
    
    // MARK: handleResponse (Dictionary包Dictionary型)
    func handleResponse(_ response:DataResponse<Any>, action: String, jsonRow: Int,  doneHandler:DoneHandler2) {
        switch response.result {
        case .success(let json):
            print("doPOST success with result:\n \(json)")   //json String
            
            let resultJSON1 = json as! [String:Any]
            print("1: \n \(resultJSON1)")
            
            if  resultJSON1[action] != nil{
            let resultJSON2 = resultJSON1[action]! as! String
           
            print("2: \n \(resultJSON2)")
            
            let data = resultJSON2.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                print("json: \n \(json)")
                
                doneHandler(nil, json)
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                doneHandler(error, nil)
                
            }
            } else if resultJSON1["nearbyItems"] != nil{
                
                let resultJSON2 = resultJSON1["nearbyItems"]! as! String
                
                print("2: \n \(resultJSON2)")
                
                let data = resultJSON2.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                    print("json: \n \(json)")
                    
                    doneHandler(nil, json)
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    doneHandler(error, nil)
                    
                }
                
            }
            
        case .failure(let error):
            NSLog("doPOST fail with error: \(error)")
            doneHandler(error, nil)
        }
        
    }
    // MARK: - 上傳日記用
    func handleResponse(_ response:DataResponse<Any>,  doneHandler:UpdateDoneHandler) {
        switch response.result {
        case .success(let json):
             let result = json as? Int
                 doneHandler(nil,result)
           
        case .failure(let error):
            NSLog("doPOST fail with error: \(error)")
            doneHandler(error, nil)
        }
        
    }
    
    // MARK: - 上傳地標用
    func handleResponse(_ response:DataResponse<Any>,  doneHandler:UpdateLandmarkDoneHandler) {
        switch response.result {
        case .success(let json):
            let result = json as! String
            doneHandler(nil,result)
            
        case .failure(let error):
            NSLog("doPOST fail with error: \(error)")
            doneHandler(error, nil)
        }
        
    }
    
    
    //UIImage轉base64
    func imageToBase64String(image:UIImage)->String?{
        //轉成Data
        guard let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }
        ///Data轉base64字符串
        var base64String=imageData.base64EncodedString()
        
        
        //base64EncodedStringWithOptions(NSData.Base64EncodingOptions(rawValue:0))
        
        return base64String
    }
    //上傳照片
    // android的imageSize=下方來取得view的寬
    //let screenWidth = self.view.frame.width
    func updatePhoto(_ finalFileURLString:String,_ parameters:Dictionary<String,Any>,doneHandler:@escaping UpdateDoneHandler) {
        
        
        Alamofire.request(finalFileURLString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in switch response.result{
        case .success(let json):
            NSLog("doPost success with result: \(json)")
            NSLog("\(json)")
            doneHandler(nil,json as! Int)
            
        case .failure(let error):
            NSLog("Download Fail:\(error)")
            doneHandler(error,nil)
            }}
    }
    
    // MARK 下載照片
    func downloadPhotoMessage(finalFileURLString:String,parameters:Dictionary<String,Any> ,doneHandler: @escaping DownloadDoneHandler) {
        Alamofire.request(finalFileURLString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in switch response.result{
        case .success(let data):
            NSLog("Download OK:\(data.count)")
            NSLog("\(data)")
            doneHandler(nil,data)
            
        case .failure(let error):
            NSLog("Download Fail:\(error)")
            doneHandler(error,nil)
            }}
    }
    
    // MARK: handleResponse (Dictionary包Dictionary型)
    func handleResponse(_ response:DataResponse<Any>, action: String, jsonRow: Int,  doneHandler:DoneHandler2) {
        switch response.result {
        case .success(let json):
            print("doPOST success with result:\n \(json)")   //json String
            
            let resultJSON1 = json as! [String:Any]
            print("1: \n \(resultJSON1)")
            var resultJSON2:String
            if action == "getFriendList"{
                  resultJSON2 = resultJSON1["friendList"]! as! String
            }else if action=="MyShareAbleCateList"{
                resultJSON2 = resultJSON1["CategorySum"]! as! String
            } else {
                resultJSON2 = resultJSON1[action]! as! String
            }
            
            let data = resultJSON2.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                print("json: \n \(json)")
                
                doneHandler(nil, json)
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                doneHandler(error, nil)
                
            }
            
            
        case .failure(let error):
            NSLog("doPOST fail with error: \(error)")
            doneHandler(error, nil)
        }
        
    }
    
    
    //UIImage轉base64
    func imageToBase64String(image:UIImage)->String?{
        //轉成Data
        guard let imageData = UIImagePNGRepresentation(image) else {
            return nil
        }
        ///Data轉base64字符串
        var base64String=imageData.base64EncodedString()
        
        
        //base64EncodedStringWithOptions(NSData.Base64EncodingOptions(rawValue:0))
        
        return base64String
    }
    // MARK:上傳照片
    // android的imageSize=下方來取得view的寬
    //let screenWidth = self.view.frame.width
    func updatePhoto(_ finalFileURLString:String,_ parameters:Dictionary<String,Any>,doneHandler:@escaping UpdateDoneHandler) {
        
        Alamofire.request(finalFileURLString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in switch response.result{
        case .success(let json):
            NSLog("doPost success with result: \(json)")
            NSLog("\(json)")
            doneHandler(nil,json as! Int)
            
        case .failure(let error):
            NSLog("Download Fail:\(error)")
            doneHandler(error,nil)
            }}
    }
    
    // MARK 下載照片
    func downloadPhotoMessage(finalFileURLString:String,parameters:Dictionary<String,Any> ,doneHandler: @escaping DownloadDoneHandler) {
        Alamofire.request(finalFileURLString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in switch response.result{
        case .success(let data):
            NSLog("Download OK:\(data.count)")
            NSLog("\(data)")
            doneHandler(nil,data)
            
        case .failure(let error):
            NSLog("Download Fail:\(error)")
            doneHandler(error,nil)
            }}
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
    
    // Mark: plist defalut file 讀取 - Regan
    static func plistLoadDefault(fileKey: String, dictionary: Dictionary<String, Any>) -> Dictionary<String, Any> {
        
        //prepare file name
        let fileURL = self.fileURL(fileKey: fileKey)
        
        //returnJsonObject
        var returnJsonObject:Dictionary<String, Any>
        
        if let retrievedData = try? Data(contentsOf: fileURL) {
            // has file to read
            NSLog("plist has file \(fileURL)")
            // to load the file
            if let thisJsonObject = try? JSONSerialization.jsonObject(with: retrievedData, options: .mutableContainers) as! Dictionary<String, Any> {
                returnJsonObject = thisJsonObject
            } else {
                NSLog("Read plist has file \(fileURL) to dictionary err")
                returnJsonObject = dictionary
            }
           
        } else {
            // has no file to create one
            NSLog("plist has no file \(fileURL)")
            if let dataExample = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
                 try! dataExample.write(to: fileURL, options: .noFileProtection)
            }
            returnJsonObject = dictionary
           
        }
        return returnJsonObject
    }
    
    static func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            NSLog("無法解析JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }

   
    static func updateMemberPlistDefault(fileKey: String, dictionary: Dictionary<String, Any>) -> () {
        //prepare file name
        let fileURL = self.fileURL(fileKey: fileKey)
        var plistData = plistLoad(fileURL: fileURL)
        
        for(key,value) in dictionary {
            if let thisKey = key as? String, let thisValue = value as? String {
                plistData.updateValue(thisValue, forKey: thisKey)
            }
        }
        plistSave(fileURL: fileURL, dictionary: plistData)
        
    }
    
    
    
    // MARK: 製作基本Dictionary
    static func DictionaryMake(action: String, account: String, password: String) -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        dictionary.updateValue(action, forKey: "action")
        dictionary.updateValue(account, forKey: "account")
        dictionary.updateValue(password, forKey: "password")
        
        
        return dictionary
        
    }
    
    func toJsonString<T:Encodable>(_ value: T) throws -> String {
      let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(value) else{
            return""
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8)else {
            return""
        }
        
      return jsonString
    }
    
}
