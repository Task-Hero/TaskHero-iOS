//
//  TaskCatalogViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let taskCardCellIdentifier = "TaskCardCell"
    var tasks: [Task]?
    var currentSelectedCellRowNum = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.register(UINib(nibName: taskCardCellIdentifier, bundle: nil), forCellReuseIdentifier: taskCardCellIdentifier)
        
        // Use temporary data for now
        tasks = setTemporaryTaskData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCardCellIdentifier, for: indexPath) as! TaskCardCell
        cell.task = tasks?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedCellRowNum = indexPath.row
        performSegue(withIdentifier: "TaskCatalogToTaskView", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskCatalogToTaskView" {
            let task = tasks![currentSelectedCellRowNum]
            let taskDetailViewController = segue.destination as! TaskDetailViewController
            taskDetailViewController.task = task
        }
    }

    // TODO: COnnect to the real data and remove this function.
    private func setTemporaryTaskData() -> [Task] {
        let tempTaskDictionary1:[String: AnyObject] = ["name": "Server Deploy" as AnyObject,
                                                 "description": "Deploy new version of code to server" as AnyObject,
                                                 "estimated_time": 180 as AnyObject,
                                                 "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy"],
                                                          ["name": "Check Server", "description": "Description 2. "],
                                                          ["name": "Update Document", "description": "Check change log and update documents"]] as AnyObject
                                                ]
                                                          
        let tempTaskDictionary2:[String: AnyObject] = ["name": "test task 02" as AnyObject,
                                                 "description": "Deploy new version of code to server" as AnyObject,
                                                 "estimated_time": 100 as AnyObject,
                                                 "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy"],
                                                          ["name": "Check Server", "description": "Description 2. "],
                                                          ["name": "Update Document", "description": "Check change log and update documents"]] as AnyObject
        ]
        
        let tempTaskDictionary3:[String: AnyObject] = ["name": "test task 03" as AnyObject,
                                                 "description": "This task 3 description. This is just a sample text to see if auto layout is working on the cell view. This is sample. This is sample." as AnyObject,
                                                 "estimated_time": 500 as AnyObject,
                                                 "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy"],
                                                          ["name": "Check Server", "description": "Description 2. "],
                                                          ["name": "Update Document", "description": "Check change log and update documents"]] as AnyObject
        ]
        
        let tempTaskDictionary4:[String: AnyObject] = ["name": "test task 04" as AnyObject,
                                                 "description": "Deploy new version of code to server" as AnyObject,
                                                 "estimated_time": 180 as AnyObject,
                                                 "steps":[["name": "Check diff", "description": "Check the diff between the currently deployed version and theversion that you wish to deploy"],
                                                          ["name": "Check Server", "description": "Description 2. "],
                                                          ["name": "Update Document", "description": "Check change log and update documents"]] as AnyObject
                                                ]
        let tempTaskDictionary5:[String: AnyObject] = ["name": "Prepare Release SDK" as AnyObject,
                                                 "description": "Prepare for public release for a new SDK" as AnyObject,
                                                 "estimated_time": 300 as AnyObject,
                                                 "steps":[["name": "Intgeration Test for native SDK", "description": "Check basic integration test will be passed"],
                                                          ["name": "Integration Test for all plugins and adapters", "description": "Check basic integration test will be passed for all plugins and adapters patterns."],
                                                          ["name": "Update Pod", "description": "Upload the latest pod file to the server"],
                                                          ["name": "Update Document", "description": "Check the changelog and update public document if necessary."]] as AnyObject
        ]

        let task1 = Task(dictionary: tempTaskDictionary1 as NSDictionary)
        let task2 = Task(dictionary: tempTaskDictionary2 as NSDictionary)
        let task3 = Task(dictionary: tempTaskDictionary3 as NSDictionary)
        let task4 = Task(dictionary: tempTaskDictionary4 as NSDictionary)
        let task5 = Task(dictionary: tempTaskDictionary5 as NSDictionary)

        return [task1, task2, task3, task4, task5]
    }
}
