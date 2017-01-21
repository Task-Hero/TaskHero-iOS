//
//  HomeViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import MessageUI

class HomeViewController: UIViewController {
    
    @IBOutlet weak var instructionalView: UIView!
    var tasks: [TaskInstance]?
    var selectedTaskInstance: TaskInstance?
    var selectedCell: Int?
    var initialIndexPath: IndexPath?
    var cellSnapshot: UIView?
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var refreshImageView: UIImageView!
    var isRefreshControlAnimating = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.loadNavigationBarColors(navigationController: navigationController!)
        loadNavigationBar()
        loadTableView()
        loadTasks()
        loadCustomRefreshContents()
    }
    
    func loadTasks(refreshControl: UIRefreshControl? = nil) {
        ParseClient.sharedInstance.getAllTaskInstances(success: {(tasks) -> () in
            self.tasks = tasks
            self.tableView.reloadData()
            
            if tasks.count == 0 {
                self.instructionalView.isHidden = false
            } else {
                self.instructionalView.isHidden = true
            }
            
            if refreshControl != nil {
                refreshControl?.endRefreshing()
            }
        }, failure: {(error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        ParseClient.sharedInstance.logout()
        
    }
    
    func loadNavigationBar() {
        //title = User.current?.name        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Emblem")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToTaskDetail" {
            let taskInstance = selectedTaskInstance
            let taskDetailViewController = segue.destination as! TaskDetailViewController
            taskDetailViewController.taskInstance = taskInstance
        }
    }
    
    func presentTargetTaskDetailView(taskInstanceId: String) {
        ParseClient.sharedInstance.getAllTaskInstances(success: { (taskInstances) -> () in
            for taskInstance in taskInstances {
                if taskInstance.id == taskInstanceId {
                    self.tableView.reloadData()
                    self.selectedTaskInstance = taskInstance
                    self.performSegue(withIdentifier: "HomeToTaskDetail", sender: self)
                }
            }
        }, failure: { (error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
}

extension HomeViewController: MFMessageComposeViewControllerDelegate {
    
    @IBAction func onInviteButton(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Let's get productive together! Download TaskHero today at https://itunes.apple.com/us/app/task-hero-app/id1197267347."
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
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
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(loadTasks(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
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
        selectedTaskInstance = tasks![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "HomeToTaskDetail", sender: self)
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

// MARK: custom refresh menu

extension HomeViewController {
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContent", owner: self, options: nil)
        customView = refreshContents?[0] as! UIView
        customView.frame = refreshControl.bounds
        refreshImageView = customView.viewWithTag(1) as! UIImageView
        refreshControl.addSubview(customView)
    }
    
    func animateRefreshControl() {
        isRefreshControlAnimating = true
        
        UIView.animate(withDuration: 2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.refreshImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
            self.refreshImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { (finished) -> Void in
            if (self.refreshControl!.isRefreshing) {
                self.animateRefreshControl()
            } else {
                self.isRefreshControlAnimating = false
                self.refreshImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isRefreshControlAnimating {
                animateRefreshControl()
            }
        }
    }
    
}
