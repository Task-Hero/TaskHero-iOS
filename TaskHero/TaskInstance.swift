//
//  TaskInstance.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation
import Parse

class TaskInstance: NSObject {
    var name: String?
    var details: String?
    var estimatedTime: TimeInterval?
    var steps: [Step]?
    var chatId: String?
    
    init(taskInstance: PFObject) {
        super.init()
        
        self.name = taskInstance["name"] as? String
        self.details = taskInstance["details"] as? String
        self.getSteps(steps: (taskInstance["steps"] as? String)!)
        
        if let estimatedTime = taskInstance["estimated_time"] {
            self.estimatedTime = estimatedTime as? TimeInterval
        } else {
            self.estimatedTime = 0.0
        }
        if let chatId = taskInstance["chatId"] {
            self.chatId = chatId as? String
        }
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
    
    func getPercentComplete() -> Double {
        let total_steps = steps?.count
        var completed_steps = 0.0
        
        for step in steps! {
            if step.state == StepState.completed {
                completed_steps += 1
            } else if step.state == StepState.inProgress {
                completed_steps += 0.25
            }
        }
        
        return completed_steps / Double(total_steps!)
    }
    
    func getLastCompletedStep() -> Step? {
        var last_completed_step_index = 0
        
        for (index, step) in (steps)!.enumerated() {
            if step.state == StepState.completed {
                last_completed_step_index = index
            }
        }
        
        return steps?[last_completed_step_index]
    }
    
    func getInvolvedUsers() -> [User] {
        var users = [User]()
        var emails = [String]()
        
        for step in steps! {
            for user in step.assignees! {
                if !emails.contains(user.email!) {
                    emails.append(user.email!)
                    users.append(user)
                }
            }
        }
        
        return users
    }
    
}
