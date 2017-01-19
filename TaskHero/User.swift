//
//  User.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse
import MD5Digest

class User: NSObject {
    
    static let didLogoutNotification = "userDidLogout"
    
    var id: String?
    var name: String?
    var team: String?
    var email: String? {
        didSet {
            setProfileImageUrl()
        }
    }
    
    var profileImageUrl: URL!
    
    override init() {
        super.init()
        
        self.setProfileImageUrl()
    }
    
    init(user: PFObject) {
        super.init()
        
        self.id = user.objectId
        self.email = user["email"] as? String
        self.name = user["name"] as? String
        self.team = user["team"] as? String
        self.setProfileImageUrl()
    }
    
    private static var _current: User?
    class var current: User? {
        get {
            if _current != nil {
                return _current
            }
            
            if let user = PFUser.current() {
                _current = User(user: user)
            }
            
            return _current
        }
    }
    
    private func setProfileImageUrl() {
        profileImageUrl = gravatarProfileImageUrl()
    }
    
    private func gravatarProfileImageUrl() -> URL {
        let emailHash = (email ?? "garbage").md5Digest()
        let url = "https://www.gravatar.com/avatar/\(emailHash)?d=mm&s=64"
        return URL(string: url)!
    }
}
