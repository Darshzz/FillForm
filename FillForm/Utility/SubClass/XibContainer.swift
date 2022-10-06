//
//  XibContainer.swift
//  CustomView_Ownership
//
//  Created by Darshan Mothreja on 08/07/20.
//  Copyright © 2020 Darshan Mothreja. All rights reserved.
//

import UIKit

@IBDesignable
class XibContainer : UIView {
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        contentView = loadViewFromNib()
        self.addSubview(contentView!)
        contentView?.createConstraintsContiners(attributes: [(.leading, 0, self, .leading, 1 ,.equal),
        (.top, 0, self, .top, 1 , .equal),
        (.trailing, 0, self, .trailing, 1 , .equal),
        (.bottom, 0, self, .bottom, 1 , .equal),], active: true)
       
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle.main//(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}




