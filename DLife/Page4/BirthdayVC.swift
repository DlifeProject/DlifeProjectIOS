//
//  BirthdayVC.swift
//  D.Life
//
//  Created by regan on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class BirthdayVC: UIViewController {

    var orignalBirthday:String = ""
    let userAccount = Common.getUserAccount()
    let userPassword = Common.getUserPassword()
    var datePicker = UIDatePicker()
    let formatter = DateFormatter()
    @IBOutlet weak var birthdayTF: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitBTOutlet: UIButton!
    @IBAction func submitBT(_ sender: UIButton) {
        
        let myPost = ["action":"changeBirthday",
                      "account":userAccount,
                      "password":userPassword,
        "newBirthday":birthdayTF.text] as [String:Any]
        Common.shared.text3(api: Common.LOGIN_URL, jsonDictionary: myPost, doneHandler: { (error, response) in
            NSLog("submit birthday return \(String(describing: response))")
            if error != nil {
                NSLog("birthday to submin error:\(String(describing: error))")
                return
            }else if (response == "birthdayUpdateSuccess") {
                guard let thisbirthday = self.birthdayTF.text else {
                    return
                }
                self.orignalBirthday = thisbirthday
                self.messageLabel.text = "update success"
                self.submitBTOutlet.isHidden = true
                self.birthdayTF.text = thisbirthday
            }
        })
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        if(orignalBirthday == "0000-00-00"){
            datePicker.date = Common.getDayformString(myDay: Common.getDayfromSetYear(offset: 18))
        }else{
            datePicker.date = Common.getDayformString(myDay: orignalBirthday)
        }
        
        // 可以選擇的最早日期時間
        let fromDateTime = formatter.date(from: Common.getDayfromSetYear(offset: 16))
        
        // 設置可以選擇的最早日期時間
        datePicker.maximumDate = fromDateTime
        birthdayTF.inputView = datePicker
        birthdayTF.inputAccessoryView = toolbar
        
    }

    @objc func donedatePicker(){
        birthdayTF.text = formatter.string(
            from: datePicker.date)
        self.view.endEditing(true)
        checkBirthdayChange()
    }
    
    @objc func cancelDatePicker(){
        birthdayTF.text = orignalBirthday
        self.view.endEditing(true)
        checkBirthdayChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "YYYY-MM-dd"
        createDatePicker()
        birthdayTF.text = orignalBirthday
        checkBirthdayChange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkBirthdayChange(){
        if(birthdayTF.text == orignalBirthday) {
            submitBTOutlet.isHidden = true
            messageLabel.text = "Select your birthday"
        }else if(birthdayTF.text == "0000-00-00"){
            submitBTOutlet.isHidden = true
            messageLabel.text = "Select your birthday"
        }else {
            submitBTOutlet.isHidden = false
            messageLabel.text = ""
        }
    }

}
