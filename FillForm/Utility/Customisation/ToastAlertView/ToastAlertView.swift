//
//  ToastAlertView.swift
//  FillForm
//
//  Created by Darsh on 11/10/22.
//

import UIKit

class ToastAlertView: XibContainer {

    // MARK: Propertise
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var constraintView_Bottom: NSLayoutConstraint!
    
    var timer: Timer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setText(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.labelText.text = text
            self?.show()
        }
    }
    
    func show() {
        constraintView_Bottom.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: { [weak self] in
            self?.superview?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dismiss()
        })
    }
    
    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            
            self?.constraintView_Bottom.constant = -30
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
                self?.superview?.layoutIfNeeded()
            })
        }
    }
}
