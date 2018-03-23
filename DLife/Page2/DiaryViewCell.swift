//
//  DiaryViewCell.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var diaryNote: UILabel!
    @IBOutlet weak var ImageView: UICollectionView!
    @IBOutlet var diarySk: UILabel!
    
    var images = [Image]()
    var height: CGFloat = 0.0
    
    static var sk: Int!
    
    var diary: Diary? {
        didSet{
            Date.text = diary?.Date
            startTime.text = diary?.startTime
            endTime.text = diary?.endTime
            place.text = diary?.place
            diaryNote.text = diary?.diaryNote
            height = diaryNote.frame.height
        }
    }
    
    // collectionView的東東
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function, collectionView, "count", images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        cell.image = images[indexPath.row]
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
