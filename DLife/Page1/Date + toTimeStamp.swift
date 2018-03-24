//
//  Date + toTimeStamp.swift
//  D.Life
//
//  Created by Allen on 2018/3/20.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation

extension Date{
    func toTimeStamp() -> Int{
       return Int(self.timeIntervalSince1970)
    }
}
