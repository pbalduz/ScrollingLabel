//
//  AppDelegate.swift
//  ScrollingLabel
//
//  Created by Pablo Balduz on 27/05/2019.
//  Copyright © 2019 Pablo Balduz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        defer {
            window?.makeKeyAndVisible()
        }
        
        window?.rootViewController = ViewController()
        
        return true
    }
}

