//
//  UIImage+Addition.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import Foundation
import UIKit

extension UIImage {
    
    func base64() -> String {
        //Now use image to create into NSData format
        let imageData = self.pngData()
        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    func resizeImage(_ targetSize: CGSize = CGSize(width: 200, height: 200)) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
