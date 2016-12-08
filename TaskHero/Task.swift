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
    var id: String?
    var name: String?
    var details: String?
    var estimatedTime: TimeInterval?
    var estimatedTimeInHours: Int? {
        get {
            if let estimatedTime = estimatedTime {
                return Int(estimatedTime / 60)
            } else {
                return nil
            }
        }
    }
    var steps: [Step]?
    var taskId: String?
    var teammates: [User]?
    
    override init() {
        super.init()
    }
    
    init(task: PFObject, teammates: [User]) {
        super.init()
    
        self.id = task.objectId
        self.name = task["name"] as? String
        self.details = task["details"] as? String
        self.teammates = teammates
        self.getSteps(steps: (task["steps"] as? String)!)
        
        if let estimatedTime = task["estimated_time"] {
            self.estimatedTime = estimatedTime as? TimeInterval
        } else {
            self.estimatedTime = 0.0
        }
        
        if let task = task["task"] as? PFObject {
            self.taskId = task.objectId
        }
    }

    private func getSteps(steps: String) {
        let data = steps.data(using: .utf8)
        let stepsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
        for stepJson in stepsJson {
            let stepDictionary = stepJson as! [String: AnyObject]
            let step = Step(stepDictionary: stepDictionary, teammates: teammates)
            if self.steps == nil {
                self.steps = [step]
            } else {
                self.steps?.append(step)
            }
        }
    }
    
    func getInvolvedUsers() -> [User] {
        var users = [User]()
        var emails = [String]()
        
        for step in steps! {
            if step.assignees != nil {
                for user in step.assignees! {
                    if !emails.contains(user.email!) {
                        emails.append(user.email!)
                        users.append(user)
                    }
                }
            }
        }
        
        return users
    }
    
}
