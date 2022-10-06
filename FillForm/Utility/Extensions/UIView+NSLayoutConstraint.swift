//
//  UIView+NSLayoutConstraint.swift
//  FillForm
//
//  Created by Darsh on 06/10/22.
//

import Foundation
import UIKit

extension UIView {
    
    typealias Attributes = (firstAttribute: NSLayoutConstraint.Attribute, constant: CGFloat, toItem: Any?, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat?, relatedBy: NSLayoutConstraint.Relation)
    
    @discardableResult func createConstraintsContiners(attributes: [Attributes], active: Bool) -> [NSLayoutConstraint] {
        guard attributes.count > 0 else {return []}
        translatesAutoresizingMaskIntoConstraints = false
        return attributes.map { attribute -> NSLayoutConstraint in
            let constraint = NSLayoutConstraint(item: self, attribute: attribute.firstAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: attribute.toItem, attribute: attribute.toAttribute, multiplier: attribute.multiplier ?? 1.0, constant: attribute.constant)
            constraint.isActive = active
            return constraint
        }
    }
}
