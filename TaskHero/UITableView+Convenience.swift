//
//  UITableView+Convenience.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNib(with reuseIdentifier: String) {
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
}
