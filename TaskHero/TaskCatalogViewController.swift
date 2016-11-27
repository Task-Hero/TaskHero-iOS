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
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        
        tableView.register(UINib(nibName: taskCardCellIdentifier, bundle: nil), forCellReuseIdentifier: taskCardCellIdentifier)
        
        // Use temporary data for now
        tasks = DummyTaskData.getTaskData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskCatalogToTaslCatalogDetail" {
            let task = tasks![currentSelectedCellRowNum]
            let taskCatalogDetailViewController = segue.destination as! TaskCatalogDetailViewController
            taskCatalogDetailViewController.task = task
        }
    }
}

extension TaskCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentSelectedCellRowNum = indexPath.row
//        performSegue(withIdentifier: "TaskCatalogToTaskView", sender: nil)
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
        performSegue(withIdentifier: "TaskCatalogToTaslCatalogDetail", sender: nil)
    }
    
    func taskLongPressed(_ taskCell:TaskCardCell) {   
        
    }
}




