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
    
    func loadStepImage(taskInstance: TaskInstance, step: Step, success: @escaping (UIImage) -> (), failure: @escaping (Error) -> ()) {
        let taskInstanceObject = PFObject(className: "TaskInstance")
        taskInstanceObject.objectId = taskInstance.id
        
        let query = PFQuery(className: "StepImage")
        query.whereKey("taskInstance", equalTo: taskInstanceObject)
        query.whereKey("step", equalTo: step.name!)
        query.addDescendingOrder("updatedAt")
        
        query.getFirstObjectInBackground(block: { (object, error) in
            if error == nil {
                let file = object?.value(forKey: "image") as! PFFile
                file.getDataInBackground(block: { (data, error) in
                    if error == nil {
                        let image = UIImage(data: data!)
                        success(image!)
                    } else {
                        failure(error!)
                    }
                })
            } else {
                failure(error!)
            }
        })
    }
    
    func saveStepImage(taskInstance: TaskInstance, step: Step, image: UIImage, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let taskInstanceObject = PFObject(className: "TaskInstance")
        taskInstanceObject.objectId = taskInstance.id
    
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        let file = PFFile(name: "img", data: imageData!)
        
        let object = PFObject(className: "StepImage")
        object["taskInstance"] = taskInstanceObject
        object["step"] = step.name!
        object["image"] = file
        
        object.saveInBackground(block: { (saved, error) in
            if error == nil {
                success()
            } else {
                failure(error!)
            }
        })
    }

    func updateTaskInstance(taskInstance: TaskInstance, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "TaskInstance")
        query.whereKey("objectId", equalTo: taskInstance.id!)
        query.getFirstObjectInBackground(block: { (object, error) -> Void in
            if (error == nil) {
                
                if let steps = taskInstance.steps{
                    let stepsData = steps.map({ (step) -> [String : AnyObject] in
                        var assigneeIds: [String] = []
                        if let assignees = step.assignees {
                            assigneeIds = assignees.map { user in user.id! }
                        }
                        return [
                            "name": step.name as AnyObject,
                            "details": step.details as AnyObject,
                            "assignees": assigneeIds as AnyObject,
                            "state": step.state as AnyObject
                        ]
                    })
                    
                    let data = try! JSONSerialization.data(withJSONObject: stepsData, options: [])
                    let string = String(data: data, encoding: .utf8)
                    object?.setValue(string, forKey: "steps")
                    object?.setValue(taskInstance.completed, forKey: "completed")
                }
                object?.saveInBackground(block: { (saved, error) in
                    if error == nil {
                        success()
                    } else {
                        failure(error!)
                    }
                })
            } else {
                failure(error!)
            }
        })
    }
    
    func getAllTaskInstances(success: @escaping ([TaskInstance]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "TaskInstance")
        
        query.whereKey("team", equalTo: User.current?.team! as Any)
        query.order(byAscending: "completed")
        query.addDescendingOrder("updatedAt")
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasksInstances: [TaskInstance] = []
                ParseClient.sharedInstance.getTeammates(success: { (users) -> () in
                    for object in objects! {
                        let taskInstance = TaskInstance.init(taskInstance: object, teammates: users)
                        tasksInstances.append(taskInstance)
                    }
                    success(tasksInstances)
                }, failure: { (error) -> () in
                    failure(error)                    
                })
            } else {
                failure(error!)
            }
        })
    }
    
    func getAllTasks(success: @escaping ([Task]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        query.whereKey("team", equalTo: User.current?.team! as Any)
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (error == nil) {
                var tasks: [Task] = []
                ParseClient.sharedInstance.getTeammates(success: { (users) -> () in
                    for object in objects! {
                        let task = Task.init(task: object, teammates: users)
                        tasks.append(task)
                    }
                    success(tasks)
                }, failure: { (error) -> () in
                    failure(error)
                })
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
        
        if let name = task.name {
            t["name"] = name
        }
        
        if let details = task.details {
            t["details"] = details
        }
        
        if let estimatedTime = task.estimatedTime {
            t["estimated_time"] = estimatedTime
        }
        
        if let team = task.team {
            t["team"] = team
        }
    
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

        query.getObjectInBackground(withId: task.id!, block: { (object, error) -> Void in
            if error == nil {
                object!.deleteInBackground(block: { (deleteSuccess, error) in
                    if error == nil {
                        success()
                    } else {
                        failure(error!)
                    }
                })
            } else {
                failure(error!)
            }
        })
    }
    
    func updateTask(task: Task, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let query = PFQuery(className: "Task")
        
        query.getObjectInBackground(withId: task.id!, block: { (object, error) -> Void in
            if error == nil {
                object!["name"] = task.name
                object!["details"] = task.details
                object!["estimated_time"] = task.estimatedTime
                
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
                            "state": step.state as AnyObject
                        ]
                    })
                    
                    let data = try! JSONSerialization.data(withJSONObject: stepsData, options: [])
                    object!["steps"] = String(data: data, encoding: .utf8)
                }
                
                object!.saveInBackground(block: { (saveSuccess, error) in
                    if saveSuccess {
                        success()
                    } else {
                        failure(error!)
                    }
                })
            } else {
                failure(error!)
            }
        })
    }
    
    func createTaskInstance(task: Task, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current!.id
        
        let original = PFObject(className: "Task")
        original.objectId = task.id
        
        let t = PFObject(className: "TaskInstance")
        t["author"] = u
        t["name"] = task.name
        t["details"] = task.details
        t["team"] = task.team
        t["estimated_time"] = task.estimatedTime
        t["task"] = original
        t["completed"] = false
        
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
                    "state": StepState.notStarted as AnyObject
                ]
            })
            
            let data = try! JSONSerialization.data(withJSONObject: stepsData, options: [])
            t["steps"] = String(data: data, encoding: .utf8)
        }

        t.saveInBackground { (saved, error) in
            if let error = error {
                failure(error)
            } else {
                success(t.objectId!)
            }
        }
    }
    
    func getTeammates(success: @escaping ([User]) -> (), failure: @escaping (Error) -> ()) {
        let query = PFUser.query()
        query?.whereKey("team", equalTo: User.current?.team! as Any)
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
    
    func postMessage(text: String, taskInstance: TaskInstance, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        let u = PFUser()
        u.objectId = User.current?.id
        
        let t = PFObject(className: "TaskInstance")
        t.objectId = taskInstance.id
        
        let m = PFObject(className: "ChatMessage")
        m["text"] = text
        m["author"] = u
        m["taskInstance"] = t
        
        m.saveInBackground { (saved, error) in
            if let error = error {
                failure(error)
            } else {
                success(text)
            }
        }
    }
    
    func getMessages(taskInstance: TaskInstance, since: Date? = nil, success: @escaping ([Message]) -> (), failure: @escaping (Error) -> ()) {
        let t = PFObject(className: "TaskInstance")
        t.objectId = taskInstance.id
        
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
    
    func logout() {
        PFUser.logOut()
        BottomBar.instance = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil)
    }
    
    func signup(name: String, email: String, team: String, password: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        user["name"] = name
        user["team"] = team
        
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
