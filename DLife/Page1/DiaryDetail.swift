//
//  DiaryDetail.swift
//  D.Life
//
//  Created by Allen on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation

struct DiaryDetail:Codable {
    
    var sk:Int
    var member_sk:Int
    var top_category_sk:Int
    var member_location_sk:Int
    var note:String
    var start_stamp:String
    var end_stamp:String
    var start_date:String
    var end_date:String
    var latitude: Double
    var longitude:Double
    var altitude:Double
    
   
    
}
