//
//  Diary.swift
//  D.Life
//
//  Created by 康晉嘉 on 2018/3/8.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

struct Diary {
    
    static var all = [Diary]()
    
    var Date: String
    var startTime: String
    var endTime: String
    var place: String
    var diaryNote: String
    
    
    static func add(diary: Diary) {
        all.append(diary)
    }
}
