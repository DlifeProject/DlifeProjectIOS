//
//  NicknameVC.swift
//  D.Life
//
//  Created by regan on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class NicknameVC: UIViewController,UITextFieldDelegate {
   
    var orignalNickname:String = ""
    let userAccount = Common.getUserAccount()
    let userPassword = Common.getUserPassword()
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitBTOulet: UIButton!
    @IBAction func submitBT(_ sender: UIButton) {
        let postJsonDictionary = ["action":"changeNickname","account":userAccount,"password":userPassword,"newNickname":nicknameTF.text] as [String : Any]
        Common.shared.text3(api: Common.LOGIN_URL, jsonDictionary: postJsonDictionary) { (error, response) in
            if error != nil {
                NSLog("nickname to submit error:\(error)")
                return
            }else if (response == "nicknameUpdateSuccess") {
                guard let thisNickname = self.nicknameTF.text else {
                    return
                }
                self.orignalNickname = thisNickname
                self.messageLabel.text = "update success"
                self.submitBTOulet.isHidden = true
                self.nicknameTF.text = thisNickname
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTF.text = orignalNickname
        messageLabel.text = "Enter a new nickname"
        submitBTOulet.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if nicknameTF.text == orignalNickname {
           nicknameTF.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkNickname()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func checkNickname() {
        if(orignalNickname == nicknameTF.text){
           messageLabel.text = "Enter a new nickname"
        } else if(nicknameTF.text == "") {
            messageLabel.text = "Enter a new nickname"
        } else {
            messageLabel.text = ""
            submitBTOulet.isHidden = false
        }
    }

}
