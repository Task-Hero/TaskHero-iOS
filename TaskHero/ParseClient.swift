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
    
    func getAllTaskInstances(sucess: @escaping ([Task]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "TaskInstances")        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasks: [Task] = []
                for object in objects! {
                    let task = Task.init(task: object)
                    tasks.append(task)
                }
                sucess(tasks)
            } else {
                failure(error!)
            }
        })
    }
    
    func getAllTasks(sucess: @escaping ([Task]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasks: [Task] = []
                for object in objects! {
                    tasks.append(Task.init(task: object))
                }
                sucess(tasks)
            } else {
                failure(error!)
            }
        })
    }
    
    func createTask(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current!.id
        
        let t = PFObject(className: "Task")
        t["author"] = u
        t["name"] = task.name
        t["details"] = task.details
        t["estimated_time"] = task.estimatedTime
    
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
    
    func createTaskInstance(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current!.id
        
        let t = PFObject(className: "TaskInstances")
        t["author"] = u
        t["name"] = task.name
        t["details"] = task.details
        t["estimated_time"] = task.estimatedTime
        t["chat_id"] = "test_chat_id"
        t["task_id"] = task.taskPFObject
        
        if let steps = task.steps {
            let stepsData = steps.map({ (step) -> [String : AnyObject] in
                var assigneeIds: [String] = []
                if let assignees = step.assignees {
                    assigneeIds = assignees.map { user in user.id! }
                }
                
                return [
                    "name": step.name as AnyObject,
                    "details": step.details as AnyObject,
                    "assignees": assigneeIds as AnyObject,
                    "state": "not_started"  as AnyObject,
                    "completed_at": "" as AnyObject,
                    "completed_by": "" as AnyObject,
                    "sign_off_by": "" as AnyObject
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
    
    func getUser(userId: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let query = PFUser.query()
        query?.getObjectInBackground(withId: userId, block: { (userObject, error) -> Void in
            if let error = error {
                failure(error)
            } else {
                let user = User(user: userObject!)
                success(user)
            }
        })
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
    
    static func logout() {
        PFUser.logOut()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil)
    }
    
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
    
}

// MARK: functions related to push

extension ParseClient {
    
    func sendPushTo(user: User, message: String) {
        let data = ["alert": message, "badge": "Increment", "sound": "1"]
        let request = ["user": user.id!, "data": data] as [String : Any]
        PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: request as [NSObject : Any])
    }
    
    func connectCurrentUserAndInstallation() {
        let installation = PFInstallation.current()
        installation?["user"] = PFUser.current()
        installation?.saveInBackground()
    }
}
