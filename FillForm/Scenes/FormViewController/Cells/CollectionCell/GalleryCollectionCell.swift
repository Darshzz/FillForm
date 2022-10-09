//
//  GalleryCollectionCell.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    var callback: (() -> Void)!
    
    func configureCell(_ image: UIImage) {
        addImageBtn.setImage(image, for: .normal)
    }
    
    // MARK: Button Actions
    @IBAction func btnAddImage_Action(_ sender: Any) {
        callback()
    }
}

