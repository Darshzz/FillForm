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
        
        let viewModel = FormViewModel(worker: FormViewWorker())
        let viewController = FormViewController.instantiate()
        viewController.viewModel = viewModel
        
        viewModel.cancelSignal.subscribe(onNext: { [weak self] in
            self?.popController()
        })
            .disposed(by: disposebag)
        
        viewController.modalPresentationStyle = .fullScreen
        navigation.present(viewController, animated: true, completion: nil)
        
        return .never()
    }
    
    private func popController() {
        navigation.dismiss(animated: true, completion: nil)
    }
}
