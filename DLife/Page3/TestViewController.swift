////
////  TestViewController.swift
////  D.Life
////
////  Created by 魏孫詮 on 2018/3/9.
////  Copyright © 2018年 康晉嘉. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//
//
//// result :server傳回來的結果 回來是json就轉成字典
//
//let RESULT_KEY = "result"
//
//
//
//class TestViewController: UIViewController {
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let parameters:[String:Any]=["action":"photo","sk":1,"imageSize":0]
//        downloadPhotoMessage(finalFileURLString:Common.BASEURL+Common.TEST_URL,parameters:parameters ) { (error, data) in
//            if let error = error {
//                NSLog("downloadPhotoMessage fail:\(error)")
//                return
//            }
//            // success
//            guard let data = data else {
//                return
//            }
//
//            NSLog("\(data)")
//
//            self.imageView.image=UIImage(data: data)
//        }
//
//        // Do any additional setup after loading the view.
//
//        //        test("aa") { (error, data) in
//        //            if let error = error {
//        //                //...
//        //                return
//        //            }
//        //            // success
//        //            guard let nickName = data!["nick_name"] as? String else {
//        //                return
//        //            }
//        //            print(nickName)
//        //            guard  let appAccount = data!["app_account"] as! String? else {
//        //                return
//        //            }
//        //            self.label?.text=appAccount
//        //        }
//    }
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBOutlet weak var label: UILabel?
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    //    func test(_ password:String,doneHandler:@escaping DoneHandler) {
//    //        let parameters: [String : Any] = ["action":"getDiary", "account":"irv278@gmail.com","password":"Regan","categoryType":"Learning"]
//    //        doPost(urlString: "http://114.34.110.248:7070/Dlife/diary", parameters: parameters, doneHandler: doneHandler)
//    //    }
//
//    func downloadPhotoMessage(finalFileURLString:String,parameters:Dictionary<String,Any> ,doneHandler: @escaping DownloadDoneHandler) {
//        Alamofire.request(finalFileURLString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { (response) in switch response.result{
//        case .success(let data):
//            NSLog("Download OK:\(data.count)")
//            NSLog("\(data)")
//            doneHandler(nil,data)
//
//        case .failure(let error):
//            NSLog("Download Fail:\(error)")
//            doneHandler(error,nil)
//            }}
//    }
//
//    func photoTest(_ password:String,doneHandler:@escaping DoneHandler) {
//
//        let screenWidth = self.view.frame.width
//
//        let parameters: [String : Any] = ["action":"photo","sk":1,"imageSize":0]
//        doPost(urlString: "http://114.34.110.248:7070/Dlife/test", parameters: parameters, doneHandler: doneHandler)
//    }
//
//    func test(_ password:String,doneHandler:@escaping DoneHandler) {
//        let parameters: [String : Any] = ["action":"login","account":"irv278@gmail.com","password":"Regan"]
//        doPost(urlString: "http://114.34.110.248:7070/Dlife/test", parameters: parameters, doneHandler: doneHandler)
//    }
//
//    func doPost(urlString:String, parameters:[String:Any], doneHandler:@escaping DoneHandler) {
//        // Prepare parameters.
//        //        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
//        //            let error = NSError(domain: "Encode json data fail.", code: -1, userInfo: nil)
//        //            doneHandler(error, nil)
//        //            return
//        //        }
//        //        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
//        //            let error = NSError(domain: "Prepare json string fail.", code: -1, userInfo: nil)
//        //            doneHandler(error, nil)
//        //            return
//        //        }
//        //        let finalParameters = [DATA_KEY:jsonString]
//        //        NSLog("doPost Parameters: \(finalParameters)")
//
//
//        // Perform Post!
//        // jsonEncoding
//
//
//        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
//            self.handleResponse(response, doneHandler: doneHandler)
//
//        }
//    }
//    func handleResponse(_ response:DataResponse<Any>, doneHandler:DoneHandler) {
//        switch response.result {
//        case.success(let json):
//            NSLog("doPost success with result: \(json)")
//            // 因為這邊 Alamofire 都處理過 不太可能為 nil 所以幾乎用!
//            let resultJSON = json as! [String:Any]
//
//            print(resultJSON)
//
//            //let serverResult = resultJSON.first?.value
//            let serverResult = resultJSON["memberProfile"] as! String
//            print(serverResult)
//
//
//
//            // 這邊是把{"sk":3,"app_account":"irv278@gmail.com","app_pwd":"Regan","nick_name":"Regan","sex":1,"birth_year":"1985-01-01","login_date":"2018-03-09 19:11:05.0"}
//            // 這一包從json變成Data型別 讓他可以去序列化解包json
//            let data = serverResult.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//
//            print(data)
//            // 接下來把剛剛那個data 把裡面每個東西 轉成key and value
//            // 類似android我們在解一個json object
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                print(json)
//
//                // 這邊只是示範可以把解包出來的字典裡面的值印出來
//                let sk = json["sk"] as! Int
//                print("sk = \(sk)")
//                let appAccount = json["app_account"] as! String
//                print("appAccount = \(appAccount)")
//
//
//                // 成功取出可以把結果給 doneHandler東西了 [String: Any]
//                doneHandler(nil, json)
//
//            } catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
//
//
//
//
//            //let serverResult = resultJSON["memberProfile"] as! Js
//            //print(serverResult)
//            //            if serverResult {
//            //                // 成功
//            //doneHandler(nil, serverResult)
//            //            } else {
//            //                // 失敗
//            //                let error = NSError(domain: "Server Result Fail", code: -1, userInfo: nil)
//            //                doneHandler(error, resultJSON)
//            //            }
//
//        case.failure(let error):
//            NSLog("doPost fail with error: \(error)")
//            doneHandler(error, nil)
//        }
//    }
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}

