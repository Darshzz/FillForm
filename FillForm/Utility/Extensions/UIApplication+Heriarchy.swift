//
//  UIApplication+Heriarchy.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import Foundation
import UIKit

extension UIApplication {
    
    // Returns current Top Most ViewController in hierarchy of Window.
    class func topMostWindowController()->UIViewController? {
        
        var topController = UIApplication.getKeyWindow()?.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    // Returns the topViewController from stack of topMostWindowController (if in navigation).
    class func currentViewController()->UIViewController? {
        
        var currentViewController = UIApplication.topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
    
    class func getKeyWindow() -> UIWindow? {
        
        var originalKeyWindow : UIWindow? = nil
        
        if #available(iOS 13, *) {
            originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            originalKeyWindow = UIApplication.shared.keyWindow
        }
        
        return originalKeyWindow
    }
}
