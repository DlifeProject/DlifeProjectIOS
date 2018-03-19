//
//  HobbyVC.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class HobbyVC: UIViewController {

    @IBOutlet weak var diary: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var threeDay: UILabel!
    @IBOutlet weak var sevenDay: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    
    let category = Common.DictionaryMake(action: "categorySum", account: "irv278@gmail.com", password: "Regan")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Common.shared.text(api: "summary", jsonDictionary: category, jsonRow: 0){ (error, result) in
            if let error = error {
                NSLog("sendTextMessage fail: \(error)")
                return
            }
            let categoryData = result! as [[String: Any]]
            let getCategoryData = categoryData[1]
            self.diary.text = getCategoryData["note"] as? String
            self.year.text = getCategoryData["year"] as? String
            self.month.text = getCategoryData["month"] as? String
            self.day.text = getCategoryData["day"] as? String
            self.month.text = getCategoryData["month"] as? String
            self.threeDay.text = "\(getCategoryData["three_day"] as! Int)"
            self.sevenDay.text = "\(getCategoryData["seven_day"] as! Int)"
            self.label.text = "/"
            self.label2.text = "/"
            
            
        }
    }
    
    // 把Button上面的字送到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let category = sender as! UIButton
        let controller = segue.destination as! DiaryViewVC
        controller.category = category.currentTitle
    }

}
