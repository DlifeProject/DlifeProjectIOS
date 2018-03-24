//
//  String + toDegrees.swift
//  D.Life
//
//  Created by Allen on 2018/3/21.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation
import CoreLocation

extension String{
        func  toCLLoactionDegrees() -> CLLocationDegrees {
            return (self as NSString).doubleValue as CLLocationDegrees
        }
    
}
