//
//  BaseCoordinator.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation
import RxSwift

class BaseCoordinator<ResultType> {
    
    let disposebag = DisposeBag()
    private let identifier = UUID()
    var childCoordinators = [UUID: Any]()
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        
        return coordinator.start().do(onNext: { [weak self] _ in
            print("--- coordinator is freed up ---")
            self?.free(coordinator: coordinator)
        })
    }
    
    func start() -> Observable<ResultType> {
        fatalError("start method needs to be implemented in derived class")
    }
}
