//
//  AppDelegate.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/1/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Parse.initialize(with: ParseAPIKey.config);
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController        
        //self.window?.rootViewController = initialViewController

        let bottomBarViewController = instantiateViewController(identifier: "BottomBarViewController") as! BottomBarViewController
        
        let actionViewController = instantiateViewController(identifier: "RedViewController")
        actionViewController.tabBarItem.image = UIImage(named: "BarItemAddTask")
        
        let leftViewController = instantiateViewController(identifier: "GreenViewController")
        leftViewController.tabBarItem.image = UIImage(named: "BarItemProgressView")
        
        let rightViewController = instantiateViewController(identifier: "BlueViewController")
        rightViewController.tabBarItem.image = UIImage(named: "BarItemTaskCatalog")
        
        bottomBarViewController.actionViewController = actionViewController
        bottomBarViewController.leftItemViewController = leftViewController
        bottomBarViewController.rightItemViewController = rightViewController

         setRootViewController(bottomBarViewController)
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setRootViewController(_ vc: UIViewController) {
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    private func instantiateViewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

