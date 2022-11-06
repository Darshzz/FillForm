//
//  ProgressView.swift
//  FillForm
//
//  Created by Darsh on 06/10/22.
//

import UIKit

class ProgressView: XibContainer {

    // MARK: Propertise
    @IBOutlet var checkmarks: [UIImageView]!
    @IBOutlet var progressLines: [UIView]!
    
    private var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func next() {
        if currentIndex == checkmarks.count - 1 { return }
        
        // Set checkmark image
        configureCheckmarks(true)
        // Animate divider lines from left to right
        configureProgressline(true)
        
        currentIndex += 1
        
        checkmarks[currentIndex].pulsate()
        checkmarks[currentIndex].borderColor = .white
    }
    
    func previous() {
        if currentIndex == 0 { return }
        
        configureCheckmarks(false)
        checkmarks[currentIndex].borderColor = .lightGray
        
        currentIndex -= 1
        
        configureCheckmarks(false)
        configureProgressline(false)
        checkmarks[currentIndex].borderColor = .white
    }
    
    private func configureCheckmarks(_ isNext: Bool) {
        
        let image = UIImage(named: "checked")
        checkmarks[currentIndex].image = isNext ? image : nil
    }
    
    private func configureProgressline(_ isNext: Bool) {
        if isNext {
            progressLines[currentIndex].startProgressAnimation(.white)
        }else if currentIndex <= 4 {
            progressLines[currentIndex].layer.sublayers?.removeAll()
            progressLines[currentIndex].setNewLayer()
        }
    }
}
