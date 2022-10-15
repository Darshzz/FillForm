//
//  GalleryTableCell.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import UIKit
import RxSwift
import RxRelay

class GalleryTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var signalMultipleImages: PublishSubject<([UIImage])>? = .init()
    var signalItemSelected: PublishRelay<(IndexPath)>?
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>?
    
    lazy var images: [UIImage] = []
    lazy var imagePicker = ImagePicker()
    
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
        imagePicker.callBackImage = { [weak self] imageSelected in
            
            guard let weakSelf = self else { return }
            
            if weakSelf.images.count < 5 {
                weakSelf.images.append(imageSelected.resizeImage()!)
    
                DispatchQueue.main.async {
                    weakSelf.collectionView.reloadData()
                }
                weakSelf.signalMultipleImages?.onNext(weakSelf.images)
            }
        }
    }
}
