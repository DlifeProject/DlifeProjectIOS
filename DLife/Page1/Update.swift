////
////  Update.swift
////  D.Life
////
////  Created by Allen on 2018/3/13.
////  Copyright © 2018年 康晉嘉. All rights reserved.
////
//
////import Foundation
////import Alamofire
////
////typealias DoneHandler = (_ error:Error?, _ result:[String:Any]?) -> Void
////
////class Update{
////    test("aa") { (error, data) in
////    if let error = error {
////    //...
////    return
////    }
////    // success
////    guard let nickName = data!["nick_name"] as? String else {
////    return
////    }
////    print(nickName)
////    guard  let appAccount = data!["app_account"] as! String? else {
////    return
////    }
////    self.label?.text=appAccount
////    }
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
//        Alamofire.request(urlString, method: .post, parameters: finalParameters, encoding: JSONEncoding.default).responseJSON { (response) in
//
//            self.handleResponse(response, doneHandler: doneHandler)
//        }
//    }
//    private func handleResponse(_ response:DataResponse<Any>,doneHandler:DoneHandler){
//        switch response.result {
//            //json字串
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
//   // let data = serverResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//
////    do {
////    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
////    print(json)
////
////    // 這邊只是示範可以把解包出來的字典裡面的值印出來
////    let sk = json["sk"] as! Int
////    print("sk = \(sk)")
////    let appAccount = json["app_account"] as! String
////    print("appAccount = \(appAccount)")
////
////
////    // 成功取出可以把結果給 doneHandler東西了 [String: Any]
////    doneHandler(nil, json)
////
////    } catch let error as NSError {
////    print("Failed to load: \(error.localizedDescription)")
////    }
//
//}

