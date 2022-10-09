//
//  GalleryTableCell.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import UIKit
import RxRelay

class GalleryTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var images: [UIImage] = []
    lazy var imagePicker = ImagePicker()
    
    var signalItemSelected: PublishRelay<(IndexPath)>?
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension GalleryTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        
    }
}

extension GalleryTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionCell", for: indexPath) as! GalleryCollectionCell
        
        if indexPath.row < images.count {
            cell.configureCell(images[indexPath.row])
        }
        cell.callback = { [weak self] in
            self?.selectImage()
        }
        
        return cell
    }
    
    func selectImage() {
        imagePicker.openPicker()
        imagePicker.callBackImage = { [weak self] image in
            if (self?.images.count)! < 5 {
                self?.images.append(image)
    
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}
