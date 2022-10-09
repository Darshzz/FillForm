//
//  AppDelegate.swift
//  FillForm
//
//  Created by Darsh on 28/09/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure | IQKeyboardManager
        IQKeyboardManager.shared.enable                     = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
    }
}

