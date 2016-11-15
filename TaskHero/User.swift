//
//  User.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    static let userDidLogoutNotification = "userDidLogout"
    
    var pfObject: PFObject?
    var objectId: String?
    var name: String?
    var team: String?
    var email: String?
    private var passwordHash: String?
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
        self.objectId = pfObject.objectId
        self.name = pfObject["name"] as? String
        self.team = pfObject["team"] as? String
        self.email = pfObject["email"] as? String
        self.passwordHash = pfObject["password_hash"] as? String
    }
    
    func samePassword(password: String) -> Bool {
        return self.passwordHash == password
    }
    
    static private func convertPFObjectToDictionary(pfObject: PFObject) -> [String: String] {
        var dictionary: [String: String] = NSDictionary() as! [String : String]
        dictionary["objectId"] = pfObject.objectId
        dictionary["name"] = pfObject["name"] as? String
        dictionary["team"] = pfObject["team"] as? String
        dictionary["email"] = pfObject["email"] as? String
        dictionary["password_hash"] = pfObject["password_hash"] as? String
        return dictionary
    }
    
    static private func convertDictionaryToPFObject(dictionary: NSDictionary) -> PFObject {
        let pfObject = PFObject.init(className: "User")
        pfObject.setObject(dictionary["objectId"] as! String, forKey: "objectId")
        pfObject.setObject(dictionary["name"] as! String, forKey: "name")
        pfObject.setObject(dictionary["team"] as! String, forKey: "team")
        pfObject.setObject(dictionary["email"] as! String, forKey: "email")
        pfObject.setObject(dictionary["password_hash"] as! String, forKey: "password_hash")
        return pfObject
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let data = defaults.object(forKey: "currentUser") as? NSData
                
                if let data = data {
                    let dictionary = try? JSONSerialization.jsonObject(with: data as Data, options: [])
                    if dictionary == nil {
                        _currentUser = nil
                    } else {
                        let pfObject = convertDictionaryToPFObject(dictionary: dictionary as! NSDictionary)
                        _currentUser = User(pfObject: pfObject)
                    }
                }
            }
            return _currentUser
        } set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let dictionary = convertPFObjectToDictionary(pfObject: user.pfObject!)
                let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.removeObject(forKey: "currentUser")
            }
            
            defaults.synchronize()
        }
    }

}
