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
        
        let task1 = Task()
        task1.name = "Server Deploy"
        task1.details = "Deploy new version of code to server"
        task1.estimatedTime = 180
        
        let task1Step1 = Step()
        task1Step1.name = "Check diff"
        task1Step1.details = "Check the diff between the currently deployed version and theversion that you wish to deploy"
        task1Step1.state = "Complete"
        
        let task1Step2 = Step()
        task1Step2.name = "Check server"
        task1Step2.details = "Description 2."
        task1Step2.state = "IP"
        
        let task1Step3 = Step()
        task1Step3.name = "Update documentation"
        task1Step3.details = "Check change log and update documents"
        task1Step3.state = "Not Started"

        let task2 = Task()
        task2.name = "test task 02"
        task2.details = "Deploy new version of code to server"
        task2.estimatedTime = 100
        
        let task2Step1 = Step()
        task2Step1.name = "Check diff"
        task2Step1.details = "Check the diff between the currently deployed version and theversion that you wish to deploy"
        task2Step1.state = "IP"
        
        let task2Step2 = Step()
        task2Step2.name = "Check server"
        task2Step2.details = "Description 2."
        task2Step2.state = "Not Started"
        
        let task2Step3 = Step()
        task2Step3.name = "Update documentation"
        task2Step3.details = "Check change log and update documents"
        task2Step3.state = "Not Started"
        
        task1.steps = [task1Step1, task1Step2, task1Step3]
        task2.steps = [task2Step1, task2Step2, task2Step3]

        
        return [task1, task2]
    }

}
