//
//  AppDelegate.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/1/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Parse.initialize(with: ParseAPIKey.config)
        setupNotifications(application)
        registerForLogoutMessages()
        
        if User.current != nil {
            setRootViewController(BottomBarLoader.loadBottomBar())
        } else {
            setRootViewController(loadLoginScreen())
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        clearBadges()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setRootViewController(_ vc: UIViewController) {
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    private func loadLoginScreen() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    private func registerForLogoutMessages() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil, queue: OperationQueue.main, using: {(notification: Notification) -> Void in
            self.setRootViewController(self.loadLoginScreen())
        })
    }
    
}

// MARK: functions related to push

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func clearBadges() {
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground { (success, error) -> Void in
            if success {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            else {
                NSLog("Failed to clear badges")
            }
        }
    }
    
    func setupNotifications(_ application: UIApplication) {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted {
                application.registerForRemoteNotifications()
            } else {
                NSLog("Error requesting push notification authorization")
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NSLog("Registration succeeded! Token: \(token)")
        
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.channels = ["global"]
        installation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Push notifications registration failed; note that this feature not supported in the iOS Simulator, so use your phone if so.")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
            PFPush.handle(notification.request.content.userInfo)
            print("\(notification.request.content.userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            PFPush.handle(response.notification.request.content.userInfo)
            print("\(response.notification.request.content.userInfo)")
    }
}

