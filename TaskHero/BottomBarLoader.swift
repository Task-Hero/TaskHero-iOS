//
//  BottomBarLoader.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

class CreateTaskAction: ActionViewProtocol {
    func actionViewRequestedAction(bottomBarViewController: BottomBarViewController) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskNavigationController")
        bottomBarViewController.present(vc, animated: true, completion: nil)
    }
    
    func imageForActionView() -> UIImage {
        return UIImage(named: "BarItemAddTask")!
    }
}

class BottomBar {
    private init() {}
    
    private static var _instance: BottomBarViewController!
    
    static var instance: BottomBarViewController! {
        get {
            if (_instance == nil) {
                _instance = loadBottomBar()
            }
            
            return _instance
        }
        
        set {
            _instance = newValue
        }
    }
    
    private class func loadBottomBar() -> BottomBarViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let bottomBarViewController = storyboard.instantiateViewController(withIdentifier: "BottomBarViewController") as! BottomBarViewController
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        leftViewController.tabBarItem.image = UIImage(named: "BarItemProgressView")
        
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "TaskCatalogNavigationController")
        rightViewController.tabBarItem.image = UIImage(named: "BarItemTaskCatalog")

        bottomBarViewController.actionView = CreateTaskAction()
        bottomBarViewController.leftItemViewController = leftViewController
        bottomBarViewController.rightItemViewController = rightViewController
        
        return bottomBarViewController
    }
}
