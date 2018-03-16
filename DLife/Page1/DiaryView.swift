//
//  DiaryView.swift
//  D.Life
//
//  Created by Allen on 2018/3/16.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation
import UIKit
class DiaryView{
var date:String = ""
var starttime:String = ""
var endtime:String = ""
var place:String
var note:String = ""
var photoImage:UIImage?
static var all = [Diary]()
init(date:String,starttime:String,endtime:String,place:String,note:String,photoImage:UIImage) {
    self.date = date
    self.starttime = starttime
    self.endtime = endtime
    self.place = place
    self.note = note
    self.photoImage = photoImage
}
init(place:String) {
    self.place = place
}

static func add(diary:Diary)  {
    all.append(diary)
}
static func remove(at index:Int)  {
    all.remove(at:index)
}
}
