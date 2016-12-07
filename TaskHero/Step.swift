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
    var teammates: [User]?
    
    override init() {
        super.init()
    }
    
    init(stepDictionary: [String: AnyObject]?, teammates: [User]?) {
        super.init()
        
        self.name = stepDictionary?["name"] as! String?
        self.teammates = teammates
        self.getAssignees(assigneeIds: stepDictionary?["assignees"] as! [String])
        
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
    
    private func getAssignees(assigneeIds: [String]) {
        self.assignees = [User]()
        for user in teammates! {
            if assigneeIds.contains(user.id!) {                    
                self.assignees!.append(user)
            }
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
            self.completedBy? = user
        }, failure: { error in
            NSLog("Error getting user, error: \(error)")
        })
    }
        
}
