//
//  Page1VC.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class Page1VC: UIViewController {

  
    @IBOutlet weak var label: UILabel!
    
    var a: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = Common.DictionaryMake(action: "login", account: "irv278@gmail.com", password: "Regan")
        
        
        
        Common.shared.text(jsonDictionary: a){ (error, result) in
            if let error = error {
                NSLog("sendTextMessage fail: \(error)")
                return
            }
            guard  let appAccount = result!["app_account"] as! String? else {
                return
            }
        
            
        }
       
        
    }

   
}
