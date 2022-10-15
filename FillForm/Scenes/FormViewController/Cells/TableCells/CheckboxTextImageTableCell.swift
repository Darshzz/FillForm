//
//  CheckboxTextImageTableCell.swift
//  FillForm
//
//  Created by Darsh on 04/10/22.
//

import UIKit
import RxRelay

class CheckboxTextImageTableCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var imgViewCheckBox: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelsubTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    lazy var imagePicker = ImagePicker()
    var model: FormModel.Answers!
    var indexPath: IndexPath!
    
    var signalItemSelected: PublishRelay<(IndexPath)>?
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Button Action
    @IBAction func btnCheckboxSelection_Action(_ sender: Any) {
        let isChecked = imgViewCheckBox.image?.isEqual(UIImage(named: Constants.checkbox)) ?? false
        // If already checked then user is unchecking it thats why bool is true then remove all existing fields
        if isChecked {
            resetFieldsIfUnchecked()
        }
        signalMultipleItemSelected?.accept((indexPath, !isChecked))
    }
    
    @IBAction func btnAddImage_Action(_sender: Any) {
        imagePicker.openPicker()
    }
    
    private func resetFieldsIfUnchecked() {
        model.subAnswer = ""
        model.base64ImageString = ""
        addImageBtn.setImage(UIImage(named: Constants.placeHolderAddImage), for: .normal)
    }

}

extension CheckboxTextImageTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.model = model
        
        labelText.text = model.question
        textField.placeholder = model.subQuestion
        textField.text = model.subAnswer
        textField.keyboardType = UIKeyboardType(rawValue: model.keyboardType)!
        labelsubTitle.text = model.title
        
        let image = UIImage(named: model.answer ? Constants.checkbox : Constants.unchecked)
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
            addImageBtn.setImage(UIImage(named: Constants.placeHolderAddImage), for: .normal)
        }
    }
}

extension CheckboxTextImageTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.subAnswer = textField.text
    }
}
