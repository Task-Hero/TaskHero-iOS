//
//  HomeViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var tasks: [TaskInstance]?
    var selectedCell: Int?
    var initialIndexPath: IndexPath?
    var cellSnapshot: UIView?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadNavigationBar()
        loadTableView()
        loadTasks()
        reloadTableOnNotification()
    }
    
    func loadTasks() {
        ParseClient.sharedInstance.getAllTaskInstances(sucess: {(tasks) -> () in
            self.tasks = tasks
            self.tableView.reloadData()
        }, failure: {(error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        ParseClient.sharedInstance.logout()
    }
    
    func loadNavigationBar() {
        title = User.current?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToTaskDetail" {
            let task = tasks![selectedCell!]
            let taskDetailViewController = segue.destination as! TaskDetailViewController
            taskDetailViewController.taskInstance = task
        }
    }
    
}

// MARK: TableView functions

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.registerNib(with: "TaskInstanceCellTableViewCell")
        addLongPressGesture()
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
        return tasks?.count ?? 0
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

// MARK: code for drag and drop cells

extension HomeViewController {
    
    func addLongPressGesture() {
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        tableView.addGestureRecognizer(longpress)
    }
    
    func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        if sender.state == .began {
            if indexPath != nil {
                initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!)
                cellSnapshot = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                cellSnapshot?.center = center!
                cellSnapshot?.alpha = 0.0
                tableView.addSubview(cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    self.cellSnapshot?.center = center!
                    self.cellSnapshot?.transform = (self.cellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                    self.cellSnapshot?.alpha = 0.99
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        cell?.isHidden = true
                    }
                })
            }
        } else if sender.state == .changed {
            var center = cellSnapshot?.center
            center?.y = locationInView.y
            cellSnapshot?.center = center!
            
            if ((indexPath != nil) && (indexPath != initialIndexPath)) {
                swap(&tasks![indexPath!.row], &tasks![initialIndexPath!.row])
                tableView.moveRow(at: initialIndexPath!, to: indexPath!)
                initialIndexPath = indexPath
            }
        } else if sender.state == .ended {
            let cell = tableView.cellForRow(at: initialIndexPath!)
            cell?.isHidden = false
            cell?.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.cellSnapshot?.center = (cell?.center)!
                self.cellSnapshot?.transform = CGAffineTransform.identity
                self.cellSnapshot?.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    self.initialIndexPath = nil
                    self.cellSnapshot?.removeFromSuperview()
                    self.cellSnapshot = nil
                }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
}
