//
//  DiaryViewVC.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var DiaryView: UITableView!
    
    var diarys = Diary.all
    let diaryData: Dictionary<String, Any> = ["action":"getDiary","account":"irv278@gmail.com","password":"Regan","categoryType":"Shopping"]
    
    
    
    // tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DiaryView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryViewCell
        let diary = diarys[indexPath.row]
        cell.diary = diary
        
        return cell
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 把tableView分隔線去掉
        DiaryView.separatorStyle = .none
        
        // 取得sever日記
        Common.shared.text(api: "diary", jsonDictionary: diaryData, jsonRow: 0){ (error, result) in
            if let error = error {
                NSLog("sendTextMessage fail: \(error)")
                return
            }
            let allDiary = result! as [[String: Any]]
            print("diary:\n \(allDiary)")
            
            for i in 0...(allDiary.count - 1) {
                let getDiary = allDiary[i]
                
                
                let start = getDiary["start_date"] as! String
                let startTimeStart = start.index(start.startIndex, offsetBy: 11)
                let startTimeEnd = start.index(startTimeStart, offsetBy: 5)
                let startTime = start[startTimeStart..<startTimeEnd]
                
                let end = getDiary["end_date"] as! String
                let endTimeStart = end.index(end.startIndex, offsetBy: 11)
                let endTimeEnd = end.index(endTimeStart, offsetBy: 5)
                let endTime = end[endTimeStart..<endTimeEnd]
               

                let exDiary = Diary(Date: getDiary["post_day"] as! String,
                                        startTime: String(startTime),
                                        endTime: String(endTime),
                                        place: "這裡是地址",
                                        diaryNote: getDiary["note"] as! String)
                Diary.add(diary: exDiary)
                DiaryViewCell.awakeFromNib()
                i + 1
            }
            self.diarys = Diary.all
            self.DiaryView.reloadData()
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Diary.all = [Diary]()
        self.navigationController?.isNavigationBarHidden = true

    }
    

    
}

