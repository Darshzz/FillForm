//
//  OtherRadioTextFieldTableCell.swift
//  FillForm
//
//  Created by Darsh on 04/10/22.
//

import UIKit
import RxRelay

class OtherRadioTextFieldTableCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var imgViewRadio: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath!
    var model: FormModel.Answers!
    var signalItemSelected: PublishRelay<(IndexPath)>? = .init()
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnRadioSelection_Action(_ sender: Any) {
        let currentImage = imgViewRadio.image?.isEqual(UIImage(named: Constants.radio)) ?? false
        let image = UIImage(named: currentImage ? Constants.radio : Constants.noradio)
        imgViewRadio.image = image
        
        signalItemSelected?.accept(indexPath)
    }

}

extension OtherRadioTextFieldTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.model = model
        
        labelText.text = model.question
        textField.text = model.subAnswer
        textField.placeholder = model.subQuestion
        textField.keyboardType = UIKeyboardType(rawValue: model.keyboardType)!
        
        let image = UIImage(named: model.answer ? Constants.radio : Constants.noradio)
        imgViewRadio.image = image
    }
}

extension OtherRadioTextFieldTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.subAnswer = textField.text
    }
}
