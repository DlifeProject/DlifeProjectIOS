//
//  Image.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

struct Image {
    
    static var all = [Image]()
    
    var DiaryImage: UIImage
    
    static func add(image: Image) {
        all = [Image]()
        all.append(image)
    }
}

