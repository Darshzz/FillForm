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
}
