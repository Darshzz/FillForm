//
//  FillFormCoordinator.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation
import UIKit
import RxSwift

class FormCoordinator: BaseCoordinator<Void> {
    
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init()
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = FormViewModel()
        let viewController = FormViewController.instantiate()
        viewController.viewModel = viewModel
        viewModel.cancelSignal.subscribe(onNext: { [weak self] in
            self?.popController()
        })
            .disposed(by: disposebag)
        
        navigation.pushViewController(viewController, animated: true)
        
        return .never()
    }
    
    private func popController() {
        navigation.popViewController(animated: true)
    }
}
