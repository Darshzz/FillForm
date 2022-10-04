//
//  ViewCoordinator.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation
import RxSwift

class ViewCoordinator: BaseCoordinator<Void> {
    
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    override func start() -> Observable<Void> {
        
        let viewController = ViewController.instantiate()
        bindViewController(viewController)
        navigation.pushViewController(viewController, animated: true)
        
        return .never()
    }
    
    func bindViewController(_ vc: ViewController) {
        vc.signalPushFormView
            .subscribe(onNext: { [weak self] _ in
                self?.pushToFormView()
            })
            .disposed(by: disposebag)
    }
    
    private func pushToFormView() {
        
        let viewCoordinator = FormCoordinator(navigation: navigation)
        self.coordinate(to: viewCoordinator)
            .subscribe()
            .disposed(by: disposebag)
    }
}
