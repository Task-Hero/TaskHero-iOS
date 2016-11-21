//
//  BottomBarLoader.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

class BottomBarLoader: NSObject {
    
    class func loadBottomBar() -> BottomBarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let bottomBarViewController = storyboard.instantiateViewController(withIdentifier: "BottomBarViewController") as! BottomBarViewController
        
        let actionViewController = storyboard.instantiateViewController(withIdentifier: "CreateTaskNavigationController")
        actionViewController.tabBarItem.image = UIImage(named: "BarItemAddTask")
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        leftViewController.tabBarItem.image = UIImage(named: "BarItemProgressView")
        
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "TaskCatalogViewController")
        rightViewController.tabBarItem.image = UIImage(named: "BarItemTaskCatalog")
        
        bottomBarViewController.actionViewController = actionViewController
        bottomBarViewController.leftItemViewController = leftViewController
        bottomBarViewController.rightItemViewController = rightViewController
        
        // save install and current user at loadtime
        ParseClient.sharedInstance.connectCurrentUserAndInstallation()
        
        return bottomBarViewController
    }

}
