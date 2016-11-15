//
//  Step.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation

class Step: NSObject {
    var name: String?
    var details: String?
    var state: String?
    var assignees: [User]?
    var signoffs: [User]?
}
