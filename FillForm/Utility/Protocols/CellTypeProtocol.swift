//
//  CellTypeProtocol.swift
//  FillForm
//
//  Created by Darsh on 02/10/22.
//

import Foundation
import RxRelay
import RxSwift

protocol CellTypeProtocol: AnyObject {

    // Observe if item is selected with index. Update the tableview
    var signalItemSelected: PublishRelay<(IndexPath)>? { get set }
    // Observe if item is selected with index. Update the tableview
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? { get set }
    // Observe when user adds multiple images.
    var signalMultipleImages: PublishSubject<([UIImage])>? { get set }
    
    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath)
}

extension CellTypeProtocol {
    var signalMultipleImages: PublishSubject<([UIImage])>? {
        get {
            return .init()
        }
        set {
            
        }
    }
}
