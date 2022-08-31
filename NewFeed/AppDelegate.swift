//
//  AppDelegate.swift
//  NewFeed
//
//  Created by shaohua yang on 2022/8/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ACFEntryViewController())
        window?.makeKeyAndVisible()
        return true
    }


}

