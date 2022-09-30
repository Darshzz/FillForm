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
        navigation.pushViewController(viewController, animated: true)
        
        return .never()
    }
}
