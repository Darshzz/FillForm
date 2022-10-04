//
//  CellTypeProtocol.swift
//  FillForm
//
//  Created by Darsh on 02/10/22.
//

import Foundation
import RxRelay

protocol CellTypeProtocol: AnyObject, CellSingleItemSelected, CellMultipleItemSelected {

    func configure(_ model: FormModel.Answers, _ indexPath: IndexPath)
}

protocol CellSingleItemSelected {
    // Observe if item is selected with index. Update the tableview
    var signalItemSelected: PublishRelay<(IndexPath)>? { get set }
}

protocol CellMultipleItemSelected {
    // Observe if item is selected with index. Update the tableview
    var signalMultipleItemSelected: PublishRelay<(IndexPath, Bool)>? { get set }
}
