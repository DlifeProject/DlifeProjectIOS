//
//  GenderVC.swift
//  D.Life
//
//  Created by regan on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class GenderVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var orignalGender:Int = 2
    var didSelectGender:Int = 2
    let userAccount = Common.getUserAccount()
    let userPassword = Common.getUserPassword()
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submitBTOutlet: UIButton!
    @IBAction func submitBT(_ sender: UIButton) {
        let myPost = ["action":"changeGender",
                      "account":userAccount,
                      "password":userPassword,
                      "newBirthday":genderTF.text] as [String:Any]
        Common.shared.text3(api: Common.LOGIN_URL, jsonDictionary: myPost) { (error, response) in
            NSLog("submit gender return \(String(describing: response))")
            if error != nil {
                NSLog("birthday to submin error:\(String(describing: error))")
                return
            }else if(response == "genderUpdateSuccess") {
                
                self.orignalGender = self.didSelectGender
                self.messageLabel.text = "update success"
                self.submitBTOutlet.isHidden = true
                self.genderTF.text = Common.GENDERARRAY[self.didSelectGender]
                
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Common.GENDERARRAY.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Common.GENDERARRAY[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = "\(Common.GENDERARRAY[row])"
        didSelectGender = row
        checkGenderChange()
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "\(orignalGender)"
        let myPickerView = UIPickerView()
        myPickerView.delegate = self
        myPickerView.dataSource = self
        myPickerView.selectRow(orignalGender, inComponent: 0, animated: true)
        genderTF.inputView = myPickerView
        genderTF.text = Common.GENDERARRAY[orignalGender]
        checkGenderChange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkGenderChange() {
        
        if(Common.GENDERARRAY[orignalGender] == genderTF.text) {
            messageLabel.text = "select gender"
            submitBTOutlet.isHidden = true
        }else if(Common.GENDERARRAY[orignalGender] != genderTF.text &&  genderTF.text != "" ) {
            submitBTOutlet.isHidden = false
            messageLabel.text = ""
        }else {
            messageLabel.text = "select gender"
            submitBTOutlet.isHidden = true
        }
    }
    
}
