//
//  Message.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import Foundation
import Parse

class Message: NSObject {
    var text: String?
    var author: User?
    var createdAt: Date?
    var isMine: Bool {
        get { return author?.id == User.current?.id }
    }
    
    init(dictionary: PFObject) {
        self.createdAt = dictionary.createdAt
        self.text = dictionary["text"] as? String
        
        if let author = dictionary["author"] as? PFObject {
            self.author = User(user: author)
        }
    }
}
