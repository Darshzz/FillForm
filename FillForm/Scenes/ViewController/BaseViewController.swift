//
//  BaseViewController.swift
//  FillForm
//
//  Created by Darsh on 29/09/22.
//

import Foundation
import UIKit
import RxSwift

public protocol ViewProtocol {
    associatedtype ViewModelType: ViewModelProtocol

    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: ViewModelType! { get set }

    func setupOutput()
    func setupInput(input: ViewModelType.Output)
}

open class BaseViewController<T: ViewModelProtocol>: UIViewController, ViewProtocol {
    
    public var viewModel: T!
    
    // MARK: - Constructor

    public init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
           super.init(coder: coder)
    }
    
    public func setupInput(input: T.Output) {
        
    }
    
    public func setupOutput() {
        
    }
}

fileprivate enum AssociatedKeys {
    static var disposeBag = "ViewController dispose bag associated key"
}

extension BaseViewController {

    public fileprivate(set) var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let bag = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                            return bag
            } else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, bag, .OBJC_ASSOCIATION_RETAIN)
                return bag
            }
        }
    }
}
