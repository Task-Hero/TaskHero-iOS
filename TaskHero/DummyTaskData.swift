//
//  DummyTaskData.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class DummyTaskData: NSObject {
    
    static func getTaskData() -> [Task] {
        let tempTaskDictionary1:[String: AnyObject] = ["name": "Server Deploy" as AnyObject,
                                                       "description": "Deploy new version of code to server" as AnyObject,
                                                       "estimated_time": 180 as AnyObject,
                                                       "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy", "state": "IP"],
                                                                ["name": "Check Server", "description": "Description 2.", "state": "Complete"],
                                                                ["name": "Update Document", "description": "Check change log and update documents", "state": "IP"]] as AnyObject
        ]
        
        let tempTaskDictionary2:[String: AnyObject] = ["name": "test task 02" as AnyObject,
                                                       "description": "Deploy new version of code to server" as AnyObject,
                                                       "estimated_time": 100 as AnyObject,
                                                       "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy", "state": "Complete"],
                                                                ["name": "Check Server", "description": "Description 2.", "state": "IP"],
                                                                ["name": "Update Document", "description": "Check change log and update documents", "state": "Not Started"]] as AnyObject
        ]
        
        let tempTaskDictionary3:[String: AnyObject] = ["name": "test task 03" as AnyObject,
                                                       "description": "This task 3 description. This is just a sample text to see if auto layout is working on the cell view. This is sample. This is sample." as AnyObject,
                                                       "estimated_time": 500 as AnyObject,
                                                       "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy", "state": "IP"],
                                                                ["name": "Check Server", "description": "Description 2.", "state": "IP"],
                                                                ["name": "Update Document", "description": "Check change log and update documents", "state": "IP"]] as AnyObject
        ]
        
        let tempTaskDictionary4:[String: AnyObject] = ["name": "test task 04" as AnyObject,
                                                       "description": "Deploy new version of code to server" as AnyObject,
                                                       "estimated_time": 180 as AnyObject,
                                                       "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy", "state": "Complete"],
                                                                ["name": "Check Server", "description": "Description 2.", "state": "Complete"],
                                                                ["name": "Update Document", "description": "Check change log and update documents", "state": "Complete"]] as AnyObject
        ]
        let tempTaskDictionary5:[String: AnyObject] = ["name": "Prepare Release SDK" as AnyObject,
                                                       "description": "Prepare for public release for a new SDK" as AnyObject,
                                                       "estimated_time": 300 as AnyObject,
                                                       "steps":[["name": "Intgeration Test for native SDK", "description": "Check basic integration test will be passed", "state": "Not Started"],
                                                                ["name": "Integration Test for all plugins and adapters", "description": "Check basic integration test will be passed for all plugins and adapters patterns.", "state": "Not Started"],
                                                                ["name": "Update Pod", "description": "Upload the latest pod file to the server", "state": "Not Started"],
                                                                ["name": "Update Document", "description": "Check the changelog and update public document if necessary.", "state": "Not Started"]] as AnyObject
        ]
        
        let task1 = Task(dictionary: tempTaskDictionary1 as NSDictionary)
        let task2 = Task(dictionary: tempTaskDictionary2 as NSDictionary)
        let task3 = Task(dictionary: tempTaskDictionary3 as NSDictionary)
        let task4 = Task(dictionary: tempTaskDictionary4 as NSDictionary)
        let task5 = Task(dictionary: tempTaskDictionary5 as NSDictionary)
        
        return [task1, task2, task3, task4, task5]
    }

}
