//
//  UIimage + Resize.swift
//  HelloMyPushMessage
//
//  Created by Allen on 2018/2/21.
//  Copyright © 2018年 Allen. All rights reserved.
//

import UIKit

extension UIImage{
    func resize(maxWidthHeight:CGFloat) -> UIImage?{
        // Check if this image is already smaller than maxWidthHeight.
        if self.size.width < maxWidthHeight && self.size.height < maxWidthHeight {
            return self
        }
        //Decide final size.
        let finalSize:CGSize
        if self.size.width >= self.size.height { //Width >= Height
            let ratio = self.size.width/maxWidthHeight
            finalSize = CGSize(width: maxWidthHeight, height: self.size.height / ratio)
        } else{ //Height >= Width
            let ratio = self.size.height/maxWidthHeight
            finalSize = CGSize(width: self.size.width / ratio, height: maxWidthHeight)
        }
        //Generate new image.
        //C語言的API
        UIGraphicsBeginImageContext(finalSize)
        let drawRect = CGRect(x: 0, y: 0, width: finalSize.width, height: finalSize.height)
        self.draw(in: drawRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext() //Important!
        return result
    }
}
