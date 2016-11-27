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
        reloadTableOnNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func loadTasks() {
        ParseClient.sharedInstance.getAllTasks(sucess: {(tasks) -> () in
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
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.registerNib(with: "TaskInstanceCellTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskInstanceCellTableViewCell", for: indexPath) as! TaskInstanceCellTableViewCell
        let task = tasks?[indexPath.row]
        cell.task = task
        cell.maxWidth = view.frame.width
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
    
    func reloadTableOnNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Step.assigneeLoadedNotification), object: nil, queue: OperationQueue.main, using: {(notification: Notification) -> Void in
                self.tableView.reloadData()
        })
    }
    
}
