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
    
    override func viewWillAppear(_ animated: Bool) {
        loadTasks()
    }

    func loadTasks() {
        ParseClient.sharedInstance.getAllTasks(success: {(tasks) -> () in
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
    
    fileprivate func removeTask(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "You really want to remove this Task?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            let cell = self.tableView.cellForRow(at: indexPath) as! TaskCardCell
            cell.animateBackToOriginalPosition()
        })

        let startTaskAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
            let task = self.tasks?[indexPath.row]
            
            ParseClient.sharedInstance.deleteTask(task: task!, success: {() -> () in
                self.dismiss(animated: true, completion: nil)
                self.tasks?.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
            }, failure: {(error) -> () in
                NSLog("Error: \(error)")
            })
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(startTaskAction)
        
        present(alertController, animated: true, completion: nil)
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
    
    func taskCellWasRemoved(_ taskCell: TaskCardCell) {
        let removeTaskIndexPath = tableView.indexPath(for: taskCell)
        removeTask(at: removeTaskIndexPath!)
    }
}

