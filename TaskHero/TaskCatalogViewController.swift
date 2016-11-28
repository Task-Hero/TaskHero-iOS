//
//  TaskCatalogViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCatalogViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let taskCardCellIdentifier = "TaskCardCell"
    var tasks: [Task]?
    var currentSelectedCellRowNum = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.registerNib(with: taskCardCellIdentifier)
        
        loadTasks()
    }

    func loadTasks() {
        ParseClient.sharedInstance.getAllTasks(sucess: {(tasks) -> () in
            self.tasks = tasks
            self.tableView.reloadData()
        }, failure: {(error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskCatalogToTaskCatalogDetail" {
            let task = tasks![currentSelectedCellRowNum]
            let taskCatalogDetailViewController = segue.destination as! TaskCatalogDetailViewController
            taskCatalogDetailViewController.task = task
        }
    }
}

extension TaskCatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCardCellIdentifier, for: indexPath) as! TaskCardCell
        cell.task = tasks?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
}

extension TaskCatalogViewController: TaskCardCellDelegate {
    func taskTapped(_ taskCell:TaskCardCell) {
        let indexPath = tableView.indexPath(for: taskCell)
        currentSelectedCellRowNum = indexPath!.row
        performSegue(withIdentifier: "TaskCatalogToTaskCatalogDetail", sender: nil)
    }
    
    func taskLongPressed(_ taskCell:TaskCardCell) {
        let indexPath = tableView.indexPath(for: taskCell)
        currentSelectedCellRowNum = indexPath!.row
        
        let alertController = UIAlertController(title: "Start this task?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let startTaskAction = UIAlertAction(title: "Start", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)

            let task = self.tasks![self.currentSelectedCellRowNum]
            ParseClient.sharedInstance.createTaskInstance(task: task, success: {}, failure: {error in print(error) })
            // TODO: Go back to Homescreen
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(startTaskAction)
        
        present(alertController, animated: true, completion: nil)
    }
}




