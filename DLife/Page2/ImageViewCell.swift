//
//  ImageViewCell.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: Image? {
        didSet{
            imageView.image = image?.DiaryImage
        }
    }
}
