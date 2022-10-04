//
//  RadioButtonTableCell.swift
//  FillForm
//
//  Created by Darsh on 02/10/22.
//

import UIKit
import RxRelay

class RadioButtonTableCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var radioBtn: UIButton!
    @IBOutlet weak var labelText: UILabel!
    
    var indexPath: IndexPath!
    var signalItemSelected: PublishRelay<(IndexPath)>? = .init()
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRadioSelection_Action(_ sender: Any) {
        let currentImage = radioBtn.currentImage?.isEqual(UIImage(named: "radio")) ?? false
        let image = UIImage(named: currentImage ? "noradio":"radio")
        radioBtn.setImage(image, for: .normal)
        
        signalItemSelected?.accept(indexPath)
//        model.answer = !model.answer
    }

}

extension RadioButtonTableCell: CellTypeProtocol {
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        labelText.text = model.question
        
        let image = UIImage(named: model.answer ? "radio":"noradio")
        radioBtn.setImage(image, for: .normal)
    }
}
