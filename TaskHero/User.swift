//
//  User.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static var _currentUser: Bool? = false
    class var currentUser: Bool? {
        get { return _currentUser }
        set(user) {
            _currentUser = user
        }
    }

}
