//
//  ParseClient.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    
    func signup(name: String, email: String, password: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user["name"] = name
        user["team"] = "codepath"
        
        user.signUpInBackground { (isSuccess, error) in
            if let error = error {
                failure(error)
            } else {
                let createdUser = User(user: user)
                success(createdUser)
            }
        }
    }
    
    func login(email: String, password: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            if let error = error {
                failure(error)
            } else {
                let foundUser = User(user: user!)
                success(foundUser)
            }
        }
    }
    
    func getTeammates(success: @escaping ([User]) -> (), failure: @escaping (Error) -> ()) {
        // TODO: this could easily be constrained to teams later on
        let query = PFUser.query()
        query?.order(byAscending: "name")
        query?.findObjectsInBackground { (users, error) in
            if let error = error {
                failure(error)
            } else {
                let foundUsers = (users ?? []).map { User(user: $0) }
                success(foundUsers)
            }
        }
    }
    
    func createTask(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current!.id
        
        let t = PFObject(className: "Task")
        t["author"] = u
        t["name"] = task.name
        t["details"] = task.details
    
        if let steps = task.steps {
            let stepsData = steps.map({ (step) -> [String : AnyObject] in
                var assigneeIds: [String] = []
                if let assignees = step.assignees {
                    assigneeIds = assignees.map { user in user.id! }
                }
                
                return [
                    "name": step.name as AnyObject,
                    "details": step.details as AnyObject,
                    "assignees": assigneeIds as AnyObject
                ]
            })
            
            let data = try! JSONSerialization.data(withJSONObject: stepsData, options: [])
            t["steps"] = String(data: data, encoding: .utf8)
        }
        
        t.saveInBackground { (saved, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    static func logout() {
        PFUser.logOut()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil)
    }
}
