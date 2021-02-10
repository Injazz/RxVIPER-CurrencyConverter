//
//  AppDelegate.swift
//  currencyconvert
//
//  Created by Admin on 07.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window = window
        
        AppRouter.shared.startRouting(window: self.window!)
        return true
    }

}

