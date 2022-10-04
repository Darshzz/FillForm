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
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelsubTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var indexPath: IndexPath!
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
        
    }

}

extension CheckboxTextImageTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        labelText.text = model.question
        
        let image = UIImage(named: model.answer ? "checkbox":"unchecked")
        checkBoxBtn.setImage(image, for: .normal)

    }
}
