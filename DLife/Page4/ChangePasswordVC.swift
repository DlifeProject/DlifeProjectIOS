//
//  changePasswordVC.swift
//  D.Life
//
//  Created by regan on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController,UITextFieldDelegate {
    
    var orignalPassword:String = ""
    let userAccount = Common.getUserAccount()
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitBTOutlet: UIButton!
    @IBAction func submitBT(_ sender: UIButton) {
        let postJsonDictionary = ["action":"changePassword","account":userAccount,"password":orignalPassword,"newPassword":passwordTF.text!] as [String : Any]
        Common.shared.text3(api: Common.LOGIN_URL, jsonDictionary: postJsonDictionary) { (error, response) in
            NSLog("submit password return \(String(describing: response))")
            if error != nil {
                NSLog("password to submin error:\(String(describing: error))")
                return
            }else if (response == "passwordUpdateSuccess"){
                guard let thisPassword = self.passwordTF.text else {
                    return
                }
                self.orignalPassword = thisPassword
                self.messageLabel.text = "update success"
                self.submitBTOutlet.isHidden = true
                self.passwordTF.text = ""
                self.passwordTF.isHidden = true
                
                let updateMemberProfilePlist = [Common.PREFFERENCES_USER_PASSWORD:thisPassword]
                Common.updateMemberPlistDefault(dictionary: updateMemberProfilePlist)
                
            } else {
                self.messageLabel.text = "update fail"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //submitBTOutlet.isHidden = true
        //messageLabel.text = orignalPassword
    }
    
    override func viewWillAppear(_ animated: Bool) {
        submitBTOutlet.isHidden = true
        messageLabel.text = "Enter a new password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkPasswordChange()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(passwordTF.text != ""){
            checkPasswordChange()
        }
        self.view.endEditing(true)
    }
    
    func checkPasswordChange(){
        if(passwordTF.text == orignalPassword){
            submitBTOutlet.isHidden = true
            messageLabel.text = "Same password"
            passwordTF.text = ""
        }else {
            submitBTOutlet.isHidden = false
        }
    }
    
}
