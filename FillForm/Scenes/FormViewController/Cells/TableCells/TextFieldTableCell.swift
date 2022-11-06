//
//  TextFieldTableCell.swift
//  FillForm
//
//  Created by Darsh on 05/11/22.
//

import UIKit
import RxRelay

class TextFieldTableCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath!
    var model: FormModel.Answers!
    var signalItemSelected: PublishRelay<(IndexPath)>? = .init()
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureDatePicker() {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerFromValueChanged(sender:)), for: .valueChanged)
    }
}

extension TextFieldTableCell: CellTypeProtocol {

    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.model = model
        labelText.text = model.title
        textField.placeholder = model.subQuestion
        textField.keyboardType = UIKeyboardType(rawValue: model.keyboardType)!
    }
}

extension TextFieldTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.subAnswer = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if model.isDateTimePicker {
            configureDatePicker()
        }
    }
    
    @objc func datePickerFromValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
        textField.text = dateFormatter.string(from: sender.date)
        
    }
}
