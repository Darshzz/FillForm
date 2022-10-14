//
//  CheckboxImageTableCell.swift
//  FillForm
//
//  Created by Darsh on 04/10/22.
//

import UIKit
import RxRelay

class CheckboxImageTableCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var imgViewCheckBox: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelsubTitle: UILabel!
    @IBOutlet weak var addImageBtn: UIButton!
    
    var indexPath: IndexPath!
    lazy var imagePicker = ImagePicker()
    
    var signalItemSelected: PublishRelay<(IndexPath)>?
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Button Action
    @IBAction func btnCheckboxSelection_Action(_ sender: Any) {
        let currentImage = imgViewCheckBox.image?.isEqual(UIImage(named: "checkbox")) ?? false
        let image = UIImage(named: currentImage ? "unchecked":"checkbox")
        imgViewCheckBox.image = image
        
        signalMultipleItemSelected?.accept((indexPath, !currentImage))
    }
    
    @IBAction func btnAddImage_Action(_sender: Any) {
        imagePicker.openPicker()
    }
}

extension CheckboxImageTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        labelText.text = model.question
        labelsubTitle.text = model.title
        
        let image = UIImage(named: model.answer ? "checkbox":"unchecked")
        imgViewCheckBox.image = image
        
        configureAddButtonImage(model)
        
        imagePicker.callBackImage = { image in
            DispatchQueue.global(qos: .background).async { [weak self] in
                let resizedImage = image.resizeImage()
                model.base64ImageString = resizedImage?.base64()
                
                DispatchQueue.main.async {
                    self?.addImageBtn.setImage(resizedImage, for: .normal)
                }
            }
        }
    }
    
    private func configureAddButtonImage(_ model: FormModel.Answers) {
        if !model.base64ImageString!.isEmpty {
            DispatchQueue.global(qos: .background).async { [weak self] in
                let data: Data = NSData(base64Encoded: model.base64ImageString!, options: .ignoreUnknownCharacters)! as Data
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self?.addImageBtn.setImage(image, for: .normal)
                }
            }
        }else {
            addImageBtn.setImage(UIImage(named: "captureimage"), for: .normal)
        }
    }
}
