//
//  UIView+Convenience.swift
//  TaskHero
//
//  Created by Jonathan Como on 12/4/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib(named: String) -> UIView? {
        let tree = Bundle.main.loadNibNamed(named, owner: self, options: nil) as? [UIView]
        return tree?[0]
    }
}
