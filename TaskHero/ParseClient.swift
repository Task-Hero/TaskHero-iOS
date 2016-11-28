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
    
    func getAllTaskInstances(success: @escaping ([Task]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "TaskInstances")        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasks: [Task] = []
                for object in objects! {
                    let task = Task.init(task: object)
                    tasks.append(task)
                }
                success(tasks)
            } else {
                failure(error!)
            }
        })
    }
    
    func getAllTasks(success: @escaping ([Task]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasks: [Task] = []
                for object in objects! {
                    tasks.append(Task.init(task: object))
                }
                success(tasks)
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
    
    func deleteTask(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        query.whereKey("name", equalTo: task.name ?? "")
        query.order(byAscending: "createdAt")
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                for object in (objects! as [PFObject]) {
                    do {
                        try object.delete()
                    } catch {
                        failure(error)
                    }
                }
                success()
            } else {
                failure(error!)
            }
        })
    }
    
    func updateTask(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        query.whereKey("name", equalTo: task.name ?? "")
        query.order(byAscending: "createdAt")
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                for object in (objects! as [PFObject]) {
                    object["name"] = task.name
                    object["details"] = task.details
                    object["estimated_time"] = task.estimatedTime
                    
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
                        object["steps"] = String(data: data, encoding: .utf8)
                    }
                    
                    object.saveInBackground { (saved, error) in
                        if let error = error {
                            failure(error)
                        }
                    }
                }
                
                success()
            } else {
                failure(error!)
            }
        })
    }
    
    func createTaskInstance(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current!.id
        
        let original = PFObject(className: "Task")
        original.objectId = task.id
        
        let t = PFObject(className: "TaskInstances")
        t["author"] = u
        t["name"] = task.name
        t["details"] = task.details
        t["estimated_time"] = task.estimatedTime
        t["task"] = original
        
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
                    "state": step.state as AnyObject,
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
    
    func postMessage(text: String, task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current?.id
        
        let t = PFObject(className: "TaskInstances")
        t.objectId = task.id
        
        let m = PFObject(className: "ChatMessage")
        m["text"] = text
        m["author"] = u
        m["taskInstance"] = t
        
        m.saveInBackground { (saved, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    func getMessages(task: Task, since: Date? = nil, success: @escaping ([Message]) -> (), failure: @escaping (Error) -> ()) {
        let t = PFObject(className: "TaskInstances")
        t.objectId = task.id
        
        let query = PFQuery(className: "ChatMessage")
        query.whereKey("taskInstance", equalTo: t)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 25
        
        if let since = since {
            query.whereKey("createdAt", greaterThan: since)
        }
        
        query.findObjectsInBackground { (messages, error) in
            if let error = error {
                failure(error)
            } else {
                let foundMessages = messages?.map { Message(dictionary: $0) }
                success(foundMessages ?? [])
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
