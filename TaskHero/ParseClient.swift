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
    
    func postSample() {
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
