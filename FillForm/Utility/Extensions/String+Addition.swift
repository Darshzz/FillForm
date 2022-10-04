//
//  String+Addition.swift
//  FillForm
//
//  Created by Darsh on 03/10/22.
//

import Foundation

extension String {
    
    func isTrue() -> Bool {
        
        let value = self.lowercased()
        if value == "true" || value == "yes" {
            return true
        }
        return false
    }
}
