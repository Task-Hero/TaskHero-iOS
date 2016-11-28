//
//  HomeViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var tasks: [Task]?
    var selectedCell = -1
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadTableView()
        loadTasks()
    }
    
    func loadTasks() {
        ParseClient.sharedInstance.getAllTaskInstances(success: {(tasks) -> () in
            self.tasks = tasks
            self.tableView.reloadData()
        }, failure: {(error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        ParseClient.logout()
    }
    
    func loadNavigationBar() {
        title = User.current?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToTaskDetail" {
            let task = tasks![selectedCell]
            let taskDetailViewController = segue.destination as! TaskDetailViewController
            taskDetailViewController.task = task
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTaskCardCell", for: indexPath) as! HomeTaskCardCell
        let task = tasks?[indexPath.row]
        cell.task = task
        cell.loadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks == nil ? 0 : (tasks?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        selectedCell = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "HomeToTaskDetail", sender: self)
    }
    
}
