//
//  DiaryViewCell.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryViewCell: UITableViewCell {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var diaryNote: UILabel!
    @IBOutlet weak var ImageView: UICollectionView!
    
    var height: CGFloat = 0.0
    var Image : [UIImage]?
    
    static var sk: Int!
    var thisWidth:CGFloat = 0

    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thisWidth = CGFloat(self.frame.width)

    }
}

extension DiaryViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Image?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell, let images = Image else {
            return UICollectionViewCell()
        }
        
        print("images",images)
        let imageData = images[indexPath.item]
        cell.imageView.image = nil        
        cell.imageView.image = imageData
      
        return cell
    }
    
}

