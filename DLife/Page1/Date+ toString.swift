//
//  Date+ toString.swift
//  D.Life
//
//  Created by Allen on 2018/3/17.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }
}
