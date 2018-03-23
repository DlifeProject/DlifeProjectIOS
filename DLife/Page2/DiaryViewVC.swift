//
//  DiaryViewVC.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit
import MapKit


class DiaryViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var diarys = Diary.all
    var category: String!
    
    @IBOutlet weak var DiaryView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var diaryData = Common.DictionaryMake(action: "getDiaryBetweenDays", account: "irv278@gmail.com", password: "Regan")
    
    // tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DiaryView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryViewCell
        cell.selectionStyle = .none
        let diary = diarys[indexPath.row]
        cell.diary = diary

        let diarySk = Diary.diarySk[indexPath.row]
        
        var allPhotoSk = Common.DictionaryMake(action: "getDiaryPhotoSKList", account: "irv278@gmail.com", password: "Regan")

        print("awakeFromNib diarySk:\(diarySk)")
        
        allPhotoSk.updateValue(diarySk, forKey: "diarySK")
        Common.shared.text(api: "photo", jsonDictionary: allPhotoSk, jsonRow: 0) { (error, result) in
            if error != nil {
                print("error: \(error)")
                return
            }
            var allPhotoSk = [[String: Any]]()
            allPhotoSk = result as [[String: Any]]!
            print("allPhotoSk.count: \(allPhotoSk.count)")
            
            if allPhotoSk.count == 0 {
                cell.Image = [#imageLiteral(resourceName: "ExPhoto")]
                cell.ImageView.reloadData()
            } else {
                var photData = [UIImage]()
                for i in 0...(allPhotoSk.count - 1) {
                    
                    var photoSk: Int!
                    photoSk = allPhotoSk[i]["sk"] as! Int
                    var photo = Common.DictionaryMake(action: "getImage", account: "irv278@gmail.com", password: "Regan")
                    photo.updateValue(photoSk!, forKey: "id")
                    print("AAAAA:\(photoSk!)")
                    photo.updateValue(1080, forKey: "imageSize")
                    Common.shared.downloadPhotoMessage(finalFileURLString: Common.BASEURL + Common.PHOTO_URL, parameters: photo) { (error, result) in
                        if error != nil {
                            return
                        }
                        guard let photo = result else {
                            return
                        }
                        photData.append(UIImage(data: photo)!)
                        cell.Image = photData
                        print("countSize", photData.count)
                        cell.ImageView.reloadData()
                    }
                }
            }
        }
        cell.ImageView.contentOffset.x = 0
        cell.ImageView.reloadData()

        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 把diaryData增加新欄位
        diaryData.updateValue(PieChartVC.startDateString, forKey: "startDay")
        diaryData.updateValue(PieChartVC.endDateString, forKey: "endDay")
        var categoryListIndex: Int
        switch category {
        case "Diary":
            categoryListIndex = 0
        case "Shopping":
            categoryListIndex = 1
        case "Hobby":
            categoryListIndex = 2
        case "Learning":
            categoryListIndex = 3
        case "Travel":
            categoryListIndex = 4
        default:
            categoryListIndex = 5
        }
        diaryData.updateValue(categoryListIndex, forKey: "categoryListIndex")
        print(diaryData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 把navigation bar隱藏取消
        self.navigationController?.isNavigationBarHidden = false
        
        // 把tableView分隔線去掉
        DiaryView.separatorStyle = .none
        
        // 取得sever日記
        Common.shared.text(api: "diary", jsonDictionary: diaryData, jsonRow: 0){ (error, result) in
            if let error = error {
                NSLog("sendTextMessage fail: \(error)")
                self.loadingLabel.text = "在輸入的日期區間內\n" + "沒有" + self.category + "類別的日記"
                return
            }
            let allDiary = result! as [[String: Any]]
            print("diary:\n \(allDiary)")
            self.loadingLabel.text = ""
            
            // 把拿到的資料用for迴圈解開
            for i in 0...(allDiary.count - 1) {
                
                // 取得全部資料中的其中一項
                let getDiary = allDiary[i]
                
                // 取時間中間 hh:MM那段
                let start = getDiary["start_date"] as! String
                let startTimeStart = start.index(start.startIndex, offsetBy: 11)
                let startTimeEnd = start.index(startTimeStart, offsetBy: 5)
                let startTime = start[startTimeStart..<startTimeEnd]
                let end = getDiary["end_date"] as! String
                let endTime = end[startTimeStart..<startTimeEnd]
                let latitude = getDiary["latitude"] as! Double
                let longitude = getDiary["longitude"] as! Double
                
                // 座標轉地點
                let geoCoder = CLGeocoder()
                
                if #available(iOS 11.0, *) {
                    geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude , longitude: longitude),preferredLocale: NSLocale(localeIdentifier: "zh_TW") as Locale as Locale)
                    { (placemarks, error) in
                        if error != nil{
                            return
                        }
                        if placemarks != nil{
                            let placemark = placemarks![0] as CLPlacemark
                            let address = placemark.name!
                            
                            // 把拿到的資料喂給Diary
                            let exDiary = Diary(Date: getDiary["post_day"] as! String,
                                                startTime: String(startTime),
                                                endTime: String(endTime),
                                                place: address,
                                                diaryNote: getDiary["note"] as! String)
                            Diary.diarySk.append(getDiary["sk"] as! Int)
                            print("DiaryViewCell.sk =", DiaryViewCell.sk)
                            Diary.add(diary: exDiary)
                        }
                        self.diarys = Diary.all
                        self.DiaryView.reloadData()
                    }
                }
            }
            
        }
        
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        // 把diary裡面的項目清空
        Diary.all = [Diary]()
        // // 把navigation bar隱藏打開
        self.navigationController?.isNavigationBarHidden = true

    }
    
    

}
