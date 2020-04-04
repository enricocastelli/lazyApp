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
class AppDelegate: UIResponder, UIApplicationDelegate, StoreProvider, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Added push notification
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
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
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (done, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let challengeID = userInfo["challengeID"] as? String {
            print(challengeID)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        storeFCMToken(fcmToken)
    }
}
