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
    
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var refreshImageView: UIImageView!
    var isRefreshControlAnimating = false
    
    private var lastActionView: ActionViewProtocol!
    
    fileprivate var popover: PopoverView!
    fileprivate var dimView: UIView!
    fileprivate let popoverDuration: TimeInterval = 0.3

    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.loadNavigationBarColors(navigationController: navigationController!)
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.registerNib(with: taskCardCellIdentifier)
        
        lastActionView = BottomBar.instance.actionView
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        loadCustomRefreshContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BottomBar.instance.actionView = CreateTaskAction()
        loadTasks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let index = navigationController?.viewControllers.index(of: self)
        if (index == nil) {
            // Going back in stack - replace the old action view
            BottomBar.instance.actionView = lastActionView
        }
    }

    func loadTasks(refreshControl: UIRefreshControl? = nil) {
        ParseClient.sharedInstance.getAllTasks(success: {(tasks) -> () in
            self.tasks = tasks
            self.tableView.reloadData()
            if self.refreshControl != nil {
                self.refreshControl?.endRefreshing()
            }  
        }, failure: {(error) -> () in
            NSLog("Error: \(error)")
        })
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadTasks()
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

// MARK: custom refresh menu

extension TaskCatalogViewController {
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
        showPopover()
    }
    
    func taskCellWasRemoved(_ taskCell: TaskCardCell) {
        let removeTaskIndexPath = tableView.indexPath(for: taskCell)
        removeTask(at: removeTaskIndexPath!)
    }
}

extension TaskCatalogViewController: PopoverViewDelegate {
    func popoverViewDidSelectPrimaryAction(popoverView: PopoverView) {
        dismissPopover { 
            self.dismiss(animated: true, completion: nil)
            let task = self.tasks![self.currentSelectedCellRowNum]

            ParseClient.sharedInstance.createTaskInstance(task: task, success: { (instanceObjectId) -> () in
                BottomBar.instance.switchToLeftViewController()
                (BottomBar.instance.leftItemViewController.childViewControllers[0] as! HomeViewController).presentTargetTaskDetailView(taskInstanceId: instanceObjectId)
            }, failure: {(error) -> () in
                print("start task failed : error = \(error)")
            })
        }
    }
    
    func popoverViewDidSelectSecondaryAction(popoverView: PopoverView) {
        dismissPopover { 
            self.performSegue(withIdentifier: "TaskCatalogToTaskCatalogDetail", sender: nil)
        }
    }
    
    fileprivate func showPopover() {
        let padding: CGFloat = 30
        
        popover = UIView.loadNib(named: "PopoverView") as! PopoverView
        let size = CGSize(width: view.bounds.width - (padding * 2), height: popover.frame.height)
        let origin = CGPoint(x: padding, y: -size.height)
        popover.frame = CGRect(origin: origin, size: size)
        
        dimView = UIView(frame: BottomBar.instance.view.frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopoverOnTap))
        dimView.addGestureRecognizer(tap)
        dimView.addSubview(popover)
        
        BottomBar.instance.view.addSubview(dimView)
        BottomBar.instance.view.bringSubview(toFront: dimView)
        
        popover.primaryTitle = "Run"
        popover.secondaryTitle = "Edit"
        popover.delegate = self
        
        dimView.backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: popoverDuration) {
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self.popover.center.y = self.view.center.y
        }
    }
    
    @objc fileprivate func dismissPopoverOnTap() {
        dismissPopover(complete: nil)
    }
    
    fileprivate func dismissPopover(complete: (() -> ())?) {
        UIView.animate(
            withDuration: popoverDuration,
            animations: {
                self.popover.center.y = -self.popover.bounds.size.height
                self.dimView.backgroundColor = UIColor.clear
        },
            completion: { _ in
                self.dimView.removeFromSuperview()
                complete?()
            }
        )
    }
}
