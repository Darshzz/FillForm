//
//  AppCoordinator.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let navigation = UINavigationController()
        navigation.isNavigationBarHidden = true
        
        let viewCoordinator = ViewCoordinator(navigation: navigation)
        
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        
        return self.coordinate(to: viewCoordinator)
    }
}
