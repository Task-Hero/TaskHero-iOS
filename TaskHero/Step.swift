//
//  Step.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation

enum StepState: Int {
    case NotStarted = 0
    case InProgress = 1
    case Completed = 2
}

class Step: NSObject {
    var name: String?
    var details: String?
    var state: StepState?
    var assignees: [User]?
    var signoff: User?
    var completedBy: User?
    var completedAt: TimeInterval?
    
    override init() {
        super.init()
    }
    
    init(stepDictionary: [String: AnyObject]?) {
        super.init()
        
        self.name = stepDictionary?["name"] as! String?
        self.getAssignees(assignees: stepDictionary?["assignees"] as! [String])
        
        if let details = stepDictionary?["details"] as? String?  {
            self.details = details
        }
        if let state = stepDictionary?["state"] as? StepState?  {
            self.state = state
        }
        if let completedAt = stepDictionary?["completed_at"] {
            self.completedAt = (completedAt as! TimeInterval)
        }
        if let completedBy = stepDictionary?["completed_by"] {
            getCompletedBy(completedBy: (completedBy as! String))
        }
        if let signoff = stepDictionary?["signoff"]  {
            getSignoff(signoff: (signoff as! String))
        }
    }
    
    private func getAssignees(assignees: [String]) {
        for assignee in assignees {
            ParseClient.sharedInstance.getUser(userId: assignee, success: { (user) -> () in
                if self.assignees == nil {
                    self.assignees = [user]
                } else {
                    self.assignees?.append(user)
                }
            }, failure: { error in
                NSLog("Error getting users, error: \(error)")
            })
        }
    }
    
    private func getSignoff(signoff: String) {
        ParseClient.sharedInstance.getUser(userId: signoff, success: { (user) -> () in
            self.signoff? = user
        }, failure: { error in
            NSLog("Error getting user, error: \(error)")
        })
    }
    
    private func getCompletedBy(completedBy: String) {
        ParseClient.sharedInstance.getUser(userId: completedBy, success: { (user) -> () in
            self.signoff? = user
        }, failure: { error in
            NSLog("Error getting user, error: \(error)")
        })
    }
    
    
}
