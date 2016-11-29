//
//  UIViewController+Convenience.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
