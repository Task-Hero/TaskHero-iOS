//
//  Step.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation

class StepState: NSObject {
    static let notStarted = "not_started"
    static let inProgress = "in_progress"
    static let completed = "completed"
}

class Step: NSObject {
    var name: String?
    var details: String?
    var state: String?
    var assignees: [User]?
    var signoff: User?
    var completedBy: User?
    var completedAt: TimeInterval?
    
    static var assigneeLoadedNotification = "assignedLoaded"
    static var allAssigneeLoadedNotification = "allAssignedLoaded"
    
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
        if let state = stepDictionary?["state"] as? String?  {
            self.state = state
        }
        if let completedAt = stepDictionary?["completed_at"] as? TimeInterval {
            self.completedAt = completedAt
        }
        if let completedBy = stepDictionary?["completed_by"] as? String {
            getCompletedBy(completedBy: completedBy)
        }
        if let signoff = stepDictionary?["signoff"] as? String {
            getSignoff(signoff: signoff)
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Step.assigneeLoadedNotification), object: nil)
            }, failure: { error in
                NSLog("Error getting users, error: \(error)")
            })
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Step.allAssigneeLoadedNotification), object: nil)
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
            self.completedBy? = user
        }, failure: { error in
            NSLog("Error getting user, error: \(error)")
        })
    }
        
}
