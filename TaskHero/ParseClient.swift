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
    
    static let USER_COLLECTION: String = "User"
    
    static func getTeam(team: String, success: @escaping ([User]) -> (), failure: @escaping () -> ()) {
        let query = PFQuery(className: USER_COLLECTION)
        query.whereKey("team", equalTo: team)
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if (objects != nil ) {
                var users: [User] = [User]()
                for object in objects! {
                    users.append(User.init(pfObject: object))
                }
                success(users)
            } else {
                failure()
            }
        })
    }
    
    static func getUser(email: String, success: @escaping (User) -> (), failure: @escaping () -> ()) {
        let query = PFQuery(className: USER_COLLECTION)
        query.whereKey("email", equalTo: email)
        query.getFirstObjectInBackground(block: { (response, error) -> Void in
            if ((response) != nil) {
                let user = User.init(pfObject: response!)
                success(user)
            } else {
                failure()
            }
        })
    }
    
    static func createUser(user: User, password: String) {
        let userObject = PFObject(className: USER_COLLECTION)
        userObject.setObject(user.name!, forKey: "name")
        userObject.setObject(user.team!, forKey: "team")
        userObject.setObject(user.email!, forKey: "email")
        userObject.setObject(password, forKey: "password_hash")
        userObject.saveInBackground(block:
            { (success, error) -> Void in
                if (success) {
                    NSLog("New user created.")
                } else {
                    NSLog("Error creating user.")
                }
        })
    }
    
    static func logout() {
        User.currentUser = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

}
