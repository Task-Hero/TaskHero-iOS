//
//  Task.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class Task: NSObject {
    var name:String!
    var taskDescription:String!
    var estimatedTime:Int!
    var steps = [Step]()

    init(dictionary: NSDictionary) {
        super.init()
        //print("-------->>> \(dictionary)")

        name = dictionary["name"] as! String
        taskDescription = dictionary["description"] as! String
        estimatedTime = dictionary["estimated_time"] as! Int
        
        let stepsInDictionary = dictionary["steps"] as! [NSDictionary]
        
        for step in stepsInDictionary {
            let stepObject = Step(dictionary: step)
            steps.append(stepObject)
        }
    }
}


class Step: NSObject {
    dynamic var name:String!
    dynamic var stepDescription:String!
    //    var assignees:[TeamMember]!
    //    var signoff:TeamMember!
    
    init(dictionary: NSDictionary) {
        super.init()
        //        print("-------->>> \(dictionary)")
        
        name = dictionary["name"] as! String
        stepDescription = dictionary["description"] as! String
        
        
    }
}



class TeamMember: NSObject {
    var name:String!
    var iconUrl:URL!
    
    init(dictionary: NSDictionary) {
        super.init()
        //print("-------->>> \(dictionary)")
        
    }
}
