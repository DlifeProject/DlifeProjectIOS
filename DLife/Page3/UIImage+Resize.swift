//
//  UIImage+Resize.swift
//  D.Life
//
//  Created by 魏孫詮 on 2018/3/11.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    var base64: String{
        //轉成Data
        let imageData = UIImagePNGRepresentation(self)
        ///Data轉base64字符串
        let base64String=imageData?.base64EncodedString()
        return  base64String!
    }
    
    func resize(maxWidthHeight: CGFloat) -> UIImage? {
        // Check if this image is already smaller than maxWidthHeight.
        if self.size.width < maxWidthHeight && self.size.height < maxWidthHeight {
            return self
        }
        
        // Decide final size.
        let finalSize:CGSize
        if self.size.width >= self.size.height { // Width > Height
            let ratio = self.size.width / maxWidthHeight
            finalSize = CGSize(width: maxWidthHeight, height: self.size.height / ratio)
        } else { // Height > Width
            let ratio = self.size.height / maxWidthHeight
            finalSize = CGSize(width: self.size.width / ratio, height: maxWidthHeight)
        }
        
        // Generate new image.
        UIGraphicsBeginImageContext(finalSize)
        let drawRect = CGRect(x:0, y:0, width:finalSize.width, height: finalSize.height)
        self.draw(in: drawRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() // 這個很重要 要把創造出來的畫面清掉 這邊是Ｃ語言 Ｃ語言吃記憶體 所以要釋放
        return result
    }
}

