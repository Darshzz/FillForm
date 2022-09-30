//
//  ViewModelProtocol.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation

public protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, _ outputHandler: @escaping (_ output: Output) -> Void)
}

