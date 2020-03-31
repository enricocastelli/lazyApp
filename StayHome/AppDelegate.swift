//
//  AppDelegate.swift
//  StayHome
//
//  Created by Enrico Castelli on 22/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, StoreProvider {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let rootVC = isFirstTime() ? OnboardingVC() : HomeVC()
        let nav = Navigation(rootViewController: rootVC)
        self.window?.rootViewController = nav
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 7200) { (status, error) in
            if status == .success {
              RemoteConfig.remoteConfig().activate(completionHandler: { (error) in
                if let error = error {
                    Logger.error(error)
                }
              })
            } else {
                Logger.warning("remoteConfig fetch error")
            }
        }
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let nav = window?.rootViewController as? Navigation, let homeVC = nav.lastVC as? HomeVC else { return }
        homeVC.viewDidAppear(true)
    }
}

