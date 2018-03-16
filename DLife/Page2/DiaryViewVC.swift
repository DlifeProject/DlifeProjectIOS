//
//  DiaryViewVC.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/7.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryViewVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var DiaryView: UICollectionView!
    var diarys = Diary.all
    
    //collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diarys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DiaryView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as! DiaryViewCell
        let diary = diarys[indexPath.row]
        cell.diary = diary
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let exDiary = Diary(Date: "20XX/XX/XX", startTime: "XX:XX", endTime:  "XX:XX", place: "這裡是地址", diaryNote: "這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容這裡是日記的內容")
        Diary.add(diary: exDiary)
        diarys = Diary.all
        DiaryView.reloadData()
        
        DiaryViewCell.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPress(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

