//
//  UITableViewCell+Convenience.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        parentViewController?.present(alert, animated: true, completion: nil)
    }
    
}
