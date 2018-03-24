//
//  UIImage + toBase64.swift
//  D.Life
//
//  Created by Allen on 2018/3/22.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func toBase64String()->String?{
        //轉成Data
        guard let imageData = UIImagePNGRepresentation(self) else {
            return nil
        }
        ///Data轉base64字符串
        let base64String = imageData.base64EncodedString()
        
        //base64EncodedStringWithOptions(NSData.Base64EncodingOptions(rawValue:0))
        
        return base64String
    }
}

