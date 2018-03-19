//
//  Data+HexString.swift
//  D.Life
//
//  Created by regan on 2018/3/19.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation

extension Data {
    var hexString:String {
        return self.map{ String(format: "%02X", $0) }.joined()
    }
}

