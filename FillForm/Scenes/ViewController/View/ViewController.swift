//
//  ViewController.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import UIKit
import RxSwift

class ViewController: UIViewController, Storyboarded {

    // MARK: Propertise
    @IBOutlet weak var constraintView_Top: NSLayoutConstraint!
    
    var signalPushFormView: PublishSubject<()>! = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        constraintView_Top.constant = 0
        UIView.animate(withDuration: 1.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnPushFormView_Action(_ sender: Any) {
        signalPushFormView.onNext(())
    }
}
