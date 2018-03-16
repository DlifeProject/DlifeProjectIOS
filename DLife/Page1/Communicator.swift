//
//  Communicator.swift
//  HelloMyPushMessage
//
//  Created by Allen on 2018/2/7.
//  Copyright © 2018年 Allen. All rights reserved.
//

//import Foundation
//import Alamofire
//
//let GROUPNAME = "BP104"
//let MY_NAME = "Allen"
//
//// JSON Keys
//let ID_KEY = "id"
//let USERNAME_KEY = "UserName"
//let MESSAGES_KEY = "Messages"
//let MESSAGE_KEY = "Message"
//let DEVICETOKEN_KEY = "DeviceToken"
//let GROUPNAME_KEY = "GroupName"
//let LASTMESSAGE_ID_KEY  = "LastMessageID"
//let TYPE_KEY = "Type"
//let DATA_KEY = "data"
//let RESULT_KEY = "result"

// Design pattern: 設計模式
// Singleton: 單例模式：讓不同地方存取同一個物件實體

//typealias DoneHandler = (_ error:Error?, _ result:[String:Any]?) -> Void
//typealias DownloadDoneHandler = (_ error:Error?, _ result:Data?) -> Void
//
//class Communicator {
//    
//    // Constants
//    static let BASEURL = "http://class.softarts.cc/PushMessage/"
//    let UPDATEDEVICETOKEN_URL = BASEURL + "updateDeviceToken.php"
//    let RETRIVE_MESSAGES_URL = BASEURL + "retriveMessages2.php"
//    let SEND_MESSAGE_URL = BASEURL + "sendMessage.php"
//    let SEND_PHOTOMESSAGE_URL = BASEURL + "sendPhotoMessage.php"
//    let PHOTO_BASE_URL = BASEURL + "photos/"
//    
//    //Singleton Support.
//    static let shared = Communicator()
//    //將建構式設為private，使物件只能創造一次
//    private init(){
//        
//    }
//    
//    func updateDeviceToken(_ token:String, doneHandler:@escaping DoneHandler) {
//        
//        let parameters = [GROUPNAME_KEY:GROUPNAME,
//                          DEVICETOKEN_KEY:token,
//                          USERNAME_KEY:MY_NAME]
//        
//        doPost(urlString:UPDATEDEVICETOKEN_URL,
//               parameters:parameters,
//               doneHandler:doneHandler)
//    }
//    
//    func downloadMessages(since lastMessageID:Int, doneHandler:@escaping DoneHandler) {
//        
//        let parameters:[String:Any] = [GROUPNAME_KEY:GROUPNAME,
//                          LASTMESSAGE_ID_KEY:lastMessageID,]
//        
//        doPost(urlString:RETRIVE_MESSAGES_URL,
//               parameters:parameters,
//               doneHandler:doneHandler)
//    }
//    func downloadPhotoMessage(filename:String,doneHandler:@escaping DownloadDoneHandler){
//        let finalFileURLString = PHOTO_BASE_URL + filename
//        Alamofire.request(finalFileURLString).responseData{(response) in switch response.result{
//        case.success(let data):
//            NSLog("Download OK: \(data.count)")
//            doneHandler(nil, data)
//        case.failure(let error):
//            NSLog("Download Fail: \(error)")
//            doneHandler(error,nil)
//            }
//        }
//    }
//    
//    func sendTextMessages(_ message:String, doneHandler:@escaping DoneHandler) {
//        
//        let parameters = [GROUPNAME_KEY:GROUPNAME,
//                          MESSAGE_KEY:message,
//                          USERNAME_KEY:MY_NAME]
//        
//        doPost(urlString:SEND_MESSAGE_URL,
//               parameters:parameters,
//               doneHandler:doneHandler)
//    }
//    func sendPhotoMessages(_ data:Data, doneHandler:@escaping DoneHandler) {
//        
//        let parameters = [GROUPNAME_KEY:GROUPNAME,
//                          USERNAME_KEY:MY_NAME]
//        
//        doPost(urlString:SEND_PHOTOMESSAGE_URL,
//               parameters:parameters,
//               data:data,
//               doneHandler:doneHandler)
//    }
//    private func doPost(urlString:String,
//                        parameters:[String:Any],
//                        data:Data,
//                        doneHandler:@escaping DoneHandler){
//        //Prepare parameters.
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else{
//            let error = NSError(domain: "Encode json data fail", code: -1, userInfo: nil)
//            doneHandler(error,nil)
//            return
//        }
//        Alamofire.upload(multipartFormData: { (formData) in
//            //Prepare parameters.
//            formData.append(jsonData, withName: DATA_KEY)
//            
//            //Prepare file to be uploaded.
//            // mimeType:上傳檔案類型 withName: 跟server對接的名字
//            formData.append(data, withName: "fileToUpload", fileName: "image.jpg", mimeType: "image/jpg")
//            
//        }, to: urlString, method: .post) { (encodeResult) in
//            switch encodeResult {
//            case .success(let upload, _,_):
//                NSLog("HTTP Post Upload encode OK.")
//                upload.responseJSON{ (response) in
//                    self.handleResponse(response, doneHandler: doneHandler)
//                }
//            case .failure(let error):
//                NSLog("HTTP Post Upload encode Fail:\(error)")
//                doneHandler(error, nil)
//            }
//        }
//    }
//    
//    private func doPost(urlString:String,
//                        parameters:[String:Any],
//                        doneHandler:@escaping DoneHandler){
//        //Prepare parameters.
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else{
//            let error = NSError(domain: "Encode json data fail", code: -1, userInfo: nil)
//            doneHandler(error,nil)
//            return
//        }
//        guard let jsonString = String(data:jsonData,encoding:.utf8) else {
//            let error = NSError(domain: "Prepare json string fail", code: -1, userInfo: nil)
//            doneHandler(error,nil)
//            return
//        }
//        let finalParameters = [DATA_KEY:jsonString]
//        NSLog("doPOST Parameters:\(finalParameters)")
//        
//        //Prepare Post!
//        Alamofire.request(urlString, method: .post, parameters: finalParameters, encoding: URLEncoding.default).responseJSON { (response) in
//            
//            self.handleResponse(response, doneHandler: doneHandler)
//        }
//    }
//    private func handleResponse(_ response:DataResponse<Any>,doneHandler:DoneHandler){
//        switch response.result {
//        case .success(let json):
//            NSLog("doPost success with result: \(json)")
//            let resultJSON = json as! [String:Any]
//            let serverResult = resultJSON[RESULT_KEY] as! Bool
//            if serverResult {
//                //A Real Success.
//                doneHandler(nil,resultJSON)
//            } else {
//                //Server Result Error.
//                let error = NSError(domain: "Server Result fail", code: -1, userInfo: nil)
//                doneHandler(error,resultJSON)
//            }
//        case .failure(let error):
//            NSLog("doPost fail with error: \(error)")
//            doneHandler(error,nil)
//            
//        }
//        
//    }
//    
//}

