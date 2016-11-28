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
    
    func scrollToBottom() {
        let lastSection = numberOfSections - 1
        let numRowsInLastSection = numberOfRows(inSection: lastSection)
        let lastIndex = IndexPath(row: numRowsInLastSection - 1, section: lastSection)
        scrollToRow(at: lastIndex, at: .bottom, animated: false)
    }
}
