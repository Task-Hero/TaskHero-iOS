//
//  Task.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation
import Parse

class Task: NSObject {
    var name: String?
    var details: String?
    var estimatedTime: TimeInterval?
    var steps: [Step]?
    var taskPFObject: PFObject?
    
    override init() {
        super.init()
    }
    
    init(task: PFObject) {
        super.init()
    
        self.name = task["name"] as? String
        self.details = task["details"] as? String
        self.getSteps(steps: (task["steps"] as? String)!)
        
        if let estimatedTime = task["estimated_time"] {
            self.estimatedTime = estimatedTime as? TimeInterval
        } else {
            self.estimatedTime = 0.0
        }
        
        self.taskPFObject = task
    }

    private func getSteps(steps: String) {
        let data = steps.data(using: .utf8)
        let stepsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
        for stepJson in stepsJson {
            let stepDictionary = stepJson as! [String: AnyObject]
            let step = Step(stepDictionary: stepDictionary)
            if self.steps == nil {
                self.steps = [step]
            } else {
                self.steps?.append(step)
            }
        }
    }
        
}
