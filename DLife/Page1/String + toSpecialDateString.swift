//
//  String + toSpecialDateString.swift
//  D.Life
//
//  Created by Allen on 2018/3/22.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation

extension String{
    func toSpecialDateString(style style:String ,dateformat format:String) -> String{
        let dateformater = DateFormatter()
        dateformater.dateFormat = style
        guard let date = dateformater.date(from: self) else{
            return ""
        }
        dateformater.dateFormat = format
        return dateformater.string(from: date)
    }
}
