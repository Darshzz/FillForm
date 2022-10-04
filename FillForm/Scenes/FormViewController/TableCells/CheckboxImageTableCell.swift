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
    var signalItemSelected: PublishRelay<(IndexPath)>?
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Button Action
    @IBAction func btnCheckboxSelection_Action(_ sender: Any) {
        let currentImage = checkBoxBtn.currentImage?.isEqual(UIImage(named: "checkbox")) ?? false
        let image = UIImage(named: currentImage ? "unchecked":"checkbox")
        checkBoxBtn.setImage(image, for: .normal)
        
        print("current selection status ==== ", !currentImage)
        signalMultipleItemSelected?.accept((indexPath, !currentImage))
    }
    
    @IBAction func btnAddImage_Action(_sender: Any) {
        
    }
}

extension CheckboxImageTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        labelText.text = model.question
        
        print(indexPath)
        print("Image name === ", model.answer)
        
        let image = UIImage(named: model.answer ? "checkbox":"unchecked")
        checkBoxBtn.setImage(image, for: .normal)
    }
}
