//
//  Login.swift
//  D.Life
//
//  Created by regan on 2018/3/16.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import Alamofire

class Login: UIViewController,UITextFieldDelegate {
    
    static let MEMBERFILE = "memberprofile"
    static let MEMBERFILEPATH = Common.fileURL(fileKey: MEMBERFILE)
    var memberProfileDictionary = [String:Any]()
    var keyboardHeight:CGFloat = 0
    let keyboardHeightOffset:CGFloat = 100

    @IBOutlet weak var buttomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let myAccount = tfAccount.text else {
            return
        }
        guard let myPassword = tfPassword.text else {
            return
        }
        webLogin(myAccount, password: myPassword)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        buttomConstraint.constant =  buttomConstraint.constant + keyboardHeight - keyboardHeightOffset
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttomConstraint.constant =  buttomConstraint.constant + keyboardHeight - keyboardHeightOffset
        self.view.endEditing(true)
    }
    

    func webLogin(_ account: String, password:String) {
        
        memberProfileDictionary.updateValue(account, forKey: Common.PREFFERENCES_USER_ACCOUNT)
        memberProfileDictionary.updateValue(password, forKey: Common.PREFFERENCES_USER_PASSWORD)
        
        let memberProfile = ["ios_user_id":"iOS","app_account":account,"app_pwd":password,"sex":0] as Dictionary<String,Any>
        let memberProfileJsonString = Common.getJSONStringFromDictionary(dictionary: memberProfile as NSDictionary)
        let memberLoginJson = ["action":"login", "member":memberProfileJsonString] as Dictionary<String,Any>
        
        doWebLogin(parameters: memberLoginJson ){
            (isLogin,loginStatus) in
            if isLogin {
                self.tfAccount.text = ""
                self.tfPassword.text = ""
                Common.updateMemberPlistDefault(fileKey: "memberProfile",dictionary: self.memberProfileDictionary)
                if let checkVC = self.storyboard?.instantiateViewController(withIdentifier: "indexController") {
                    self.present(checkVC, animated: false, completion: nil)
                }
            } else {
               
            }
        }
    }
    
    func doWebLogin(parameters:Dictionary<String,Any>, downHandle:@escaping (_ isLogin:Bool, _ loginStatus:String) -> ()) -> () {
        let urlString = Common.BASEURL + Common.LOGIN_URL
        NSLog("doWebLogin : \(urlString)")
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData {
            (response) in
            switch response.result {
            case.success(let json):
                if let labString = String.init(data: json, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines){
                    if labString == "login" {
                        downHandle(true,labString)
                    }
                }
            case.failure(let error):
                if let labString = String.init(data: error as! Data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines){
                    downHandle(false,labString)
                }
            }
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        tfAccount.text = ""
        tfPassword.text = ""
    }
    
    @IBAction func reganBtn(_ sender: Any) {
        tfAccount.text = "irv278@gmail.com"
        tfPassword.text = "Regan"
    }
    @IBAction func jessicaBtn(_ sender: Any) {
        tfAccount.text = "a55665203030@gmail.com"
        tfPassword.text = "Jessica"
    }
    @IBAction func chinBtn(_ sender: Any) {
        tfAccount.text = "twodan7566@gmail.com"
        tfPassword.text = "twodan7566@gmail.com"
    }
    @IBAction func allenBtn(_ sender: Any) {
        tfAccount.text = "af19git5@gmail.com"
        tfPassword.text = "Allen"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberProfileDictionary.updateValue("", forKey: Common.PREFFERENCES_USER_ACCOUNT)
        memberProfileDictionary.updateValue("", forKey: Common.PREFFERENCES_USER_PASSWORD)
        memberProfileDictionary = Common.plistLoadDefault(fileKey: "memberProfile", dictionary: memberProfileDictionary)
        
        if let account = memberProfileDictionary[Common.PREFFERENCES_USER_ACCOUNT] as? String, let password = memberProfileDictionary[Common.PREFFERENCES_USER_PASSWORD] as? String {
            tfAccount.text = account
            tfPassword.text = password
            //webLogin(account,password: password)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveTextFieldUp(aNotification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func moveTextFieldUp(aNotification:Notification){
        //取出詳情
        let info=aNotification.userInfo
        //取出尺寸值
        //UIKeyboardFrameEndUserInfoKey 最終鍵盤在的位置
        // Any down。as!
        let sizeValue=info![UIKeyboardFrameEndUserInfoKey]as!NSValue
        //將尺寸值轉換為CGSize
        let  size=sizeValue.cgRectValue.size
        //拿出高度
        keyboardHeight = size.height
        //把底部的距離改為0
        buttomConstraint.constant =  buttomConstraint.constant - keyboardHeight + keyboardHeightOffset
        
        //利用動畫增加延遲感
        UIView.animate(withDuration: 0.25) {
            //讓他重新佈局
            self.view.layoutIfNeeded()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
