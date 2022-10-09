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
    @IBOutlet weak var checkBoxBtn: UIButton!
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
        let currentImage = checkBoxBtn.currentImage?.isEqual(UIImage(named: "checkbox")) ?? false
        let image = UIImage(named: currentImage ? "unchecked":"checkbox")
        checkBoxBtn.setImage(image, for: .normal)
        
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
        
        let image = UIImage(named: model.answer ? "checkbox":"unchecked")
        checkBoxBtn.setImage(image, for: .normal)
        
        configureAddButtonImage(model)
        
        imagePicker.callBackImage = { image in
            DispatchQueue.global(qos: .background).async { [weak self] in
                model.base64ImageString = image.base64()
                
                DispatchQueue.main.async {
                    self?.addImageBtn.setImage(image, for: .normal)
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
