//
//  Task.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation

class Task: NSObject {
    var name: String?
    var details: String?
    var estimatedTime: TimeInterval?
    var steps: [Step]?
    var author: User?
}
