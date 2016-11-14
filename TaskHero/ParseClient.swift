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
    
    static func createUser(user: User) {
        let userObject = PFObject(className: USER_COLLECTION)
        userObject.setObject(user.name!, forKey: "name")
        userObject.setObject(user.team!, forKey: "team")
        userObject.setObject(user.email!, forKey: "email")
        userObject.setObject(user.passwordHash!, forKey: "password_hash")
        userObject.saveInBackground(block:
            { (success, error) -> Void in
                if (success) {
                    NSLog("New user created.")
                } else {
                    NSLog("Error creating user.")
                }
        })
    }
    
    static func postSample() {
        let gameScore = PFObject(className: "GameScore")
        gameScore.setObject("Rob", forKey: "name")
        gameScore.setObject(95, forKey: "scoreNumber")
        gameScore.saveInBackground(block:
            { (success, error) -> Void in
                if (success) {
                    print("ya")
                } else {
                    print("nope")
                }
        })
    }

}
