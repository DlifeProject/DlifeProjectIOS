//
//  DiaryViewCell.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class DiaryViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var diaryNote: UILabel!
    @IBOutlet weak var ImageView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images = Image.all
    var height: CGFloat = 0.0
    
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
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        let image =  self.images[indexPath.row]
        cell.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = Image(DiaryImage: #imageLiteral(resourceName: "ExPhoto"))
        Image.add(image: image)
        images = Image.all
        ImageView.reloadData()
        pageControl.hidesForSinglePage = true
    }
    


}
