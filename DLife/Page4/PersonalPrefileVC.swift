//
//  PersonalPrefileVC.swift
//  D.Life
//
//  Created by regan on 2018/3/19.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class PersonalPrefileVC:UIViewController,UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    let tableViewIndex = ["Change Password","Nickname","Birthday","Gender","Login"]
    var tableViewDetail = Dictionary<String,Any>()
    var webMemberProfile = Dictionary<String,Any>()
    var thisMemberProfile = Dictionary<String,Any>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewIndex.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = tableViewIndex[indexPath.row]
        cell.detailTextLabel?.text = tableViewDetail[tableViewIndex[indexPath.row]] as? String
        print(tableViewDetail[tableViewIndex[indexPath.row]] as? String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "changePasswordSegue", sender: webMemberProfile["app_pwd"])
        case 1:
            performSegue(withIdentifier: "nicknameSegue", sender: webMemberProfile["nick_name"])
        case 2:
            performSegue(withIdentifier: "birthdaySegue", sender: webMemberProfile["birth_year"])
        case 3:
            performSegue(withIdentifier: "genderSegue", sender: webMemberProfile["sex"])
        case 4:
            performSegue(withIdentifier: "logoutSegue", sender: nil)
        default:
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changePasswordSegue" {
            let vc = segue.destination as! ChangePasswordVC
            vc.orignalPassword = sender as! String
        } else if segue.identifier == "nicknameSegue" {
            let vc = segue.destination as! NicknameVC
            vc.orignalNickname = sender as! String
        } else if segue.identifier == "birthdaySegue" {
            let vc = segue.destination as! BirthdayVC
            vc.orignalBirthday = sender as! String
        } else if segue.identifier == "genderSegue" {
            let vc = segue.destination as! GenderVC
            vc.orignalGender = sender as! Int
        }
    }
    
    func initTableViewDetail(){
        let postJsonDictionary = ["action":"memberProfile","account":thisMemberProfile[Common.PREFFERENCES_USER_ACCOUNT],"password":thisMemberProfile[Common.PREFFERENCES_USER_PASSWORD]]
        Common.shared.text(api: Common.LOGIN_URL, jsonDictionary: postJsonDictionary) { (error, result) in
            if error != nil {
                NSLog("getWebMemberProfile error:\(String(describing: error))")
                return
            }
            if let tempProfile = result as? [String:Any] {
                for (key, values) in tempProfile {
                    switch key {
                    case "app_account":
                        self.webMemberProfile[key] = values as! String
                    case "app_pwd":
                        self.webMemberProfile[key] = values as! String
                    case "fb_account":
                        self.webMemberProfile[key] = values as! String
                    case "nick_name":
                        self.webMemberProfile[key] = values as! String
                    case "sex":
                        self.webMemberProfile[key] = values as! Int
                    case "birth_year":
                        self.webMemberProfile[key] = values as! String
                    case "login_date":
                        self.webMemberProfile[key] = values as! String
                    default:
                        break
                    }
                }
            }
            self.setTableViewDetail()
            self.tableView.reloadData()
        }
        
    }
    
    func setTableViewDetail() {
        accountLabel.text = webMemberProfile["app_account"] as! String
        //accountLabel.text?.write(webMemberProfile["app_account"] as! String )
        for indexName in self.tableViewIndex {
            switch indexName {
            case "Change Password":
                self.tableViewDetail.updateValue("", forKey: indexName)
            case "Nickname":
                if let nickname = self.webMemberProfile["nick_name"] as? String {
                    self.tableViewDetail.updateValue(nickname, forKey: indexName)
                }else {
                    self.tableViewDetail.updateValue("?", forKey: indexName)
                }
            case "Birthday":
                if let birthYear = self.webMemberProfile["birth_year"] as? String {
                    self.tableViewDetail.updateValue(birthYear, forKey: indexName)
                }else {
                    self.tableViewDetail.updateValue("0000-00-00", forKey: indexName)
                }
            case "Gender":
                if let gender = self.webMemberProfile["sex"] as? Int {
                    if gender == 0 {
                        self.tableViewDetail.updateValue("Lady", forKey: indexName)
                    }else {
                        self.tableViewDetail.updateValue("Man", forKey: indexName)
                    }
                }
            case "Login":
                if let loginDate = self.webMemberProfile["login_date"] as? String {
                    self.tableViewDetail.updateValue(loginDate, forKey: indexName)
                }else {
                    self.tableViewDetail.updateValue("0000-00-00 00:00:00", forKey: indexName)
                }
            default:
                return
            }
        }
    }
    
    func getMemberProfile(){
        initTableViewDetail()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        thisMemberProfile = Common.plistLoadDefault(fileKey: Common.MEMBERFILE)
        initTableViewDetail()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
