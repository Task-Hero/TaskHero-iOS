//
//  AppColors.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 12/3/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class AppColors: NSObject {    
    static let appRed = UIColor.init(red: 243/255, green: 59/255, blue: 35/255, alpha: 1)
    static let appBlue = UIColor.init(red: 0/255, green: 142/255, blue: 218/255, alpha: 1)
    static let appGreen = UIColor.init(red: 0/255, green: 205/255, blue: 52/255, alpha: 1)
    static let appGrey = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let appMidGrey = UIColor.init(red: 203/255, green: 204/255, blue: 211/255, alpha: 1)
    static let appDarkGrey = UIColor.init(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
    static let appWhite = UIColor.white
    static let appBlack = UIColor.black
    
    static func loadNavigationBarColors(navigationController: UINavigationController) {
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppColors.appWhite]
        navigationController.navigationBar.barTintColor = AppColors.appRed
        navigationController.navigationBar.tintColor = AppColors.appWhite
    }
}
