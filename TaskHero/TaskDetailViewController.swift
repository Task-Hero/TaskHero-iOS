//
//  TaskDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var progressBarContainerView: UIView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progressBarTrailingConstraint: NSLayoutConstraint!
    
    private var lastActionView: ActionViewProtocol!
    
    var taskInstance: TaskInstance? {
        didSet {
            steps = taskInstance?.steps
        }
    }
    var steps: [Step]!
    var selectedCell: Int?
    let stepCellIdentifier = "StepDetailCell"
    var viewMaxWidth: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTopView()
        loadTableView()
        tableView.reloadData()
        
        lastActionView = BottomBar.instance.actionView
        
        setAssigneeLoadedNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        BottomBar.instance.show(animated: true)
        BottomBar.instance.actionView = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let index = navigationController?.viewControllers.index(of: self)
        if (index == nil) {
            // Going back in stack - replace the old action view
            BottomBar.instance.actionView = lastActionView
        } else {
            BottomBar.instance.hide(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewMaxWidth = progressBarContainerView.frame.width
        setPercentBarAndLabel()
    }
    
    func loadTopView() {
        taskNameLabel.text = (taskInstance!.name!)
        taskDescriptionLabel.text = taskInstance?.details
        setUserImages(users: (taskInstance?.getInvolvedUsers())!)
    }
    
    func setUserImages(users: [User]) {
        let imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
        for (index, user) in users.enumerated() {
            if index > 4 {
                break
            }
            imageViewArray[index]?.setImageWith(user.profileImageUrl)
            imageViewArray[index]?.clipsToBounds = true
            imageViewArray[index]?.layer.cornerRadius = (imageViewArray[index]?.bounds.width)! / 2
        }
    }
    
    func setPercentBarAndLabel() {
        let percentComplete = round((taskInstance?.getPercentComplete())! * 100)
        percentLabel.text = "\(percentComplete)%"
        progressBarContainerView.layer.borderWidth = 2
        progressBarContainerView.layer.borderColor = UIColor.black.cgColor
        progressBarTrailingConstraint.constant = (viewMaxWidth! - (CGFloat(percentComplete) / 100 * viewMaxWidth!))
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController {
            let vc = destination.topViewController as! StepDetailViewController
            vc.step = steps![selectedCell!]
            vc.taskInstance = taskInstance
        } else if let destination = segue.destination as? ChatViewController {
            destination.task = taskInstance
        }
    }
}

extension TaskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: stepCellIdentifier, bundle: nil), forCellReuseIdentifier: stepCellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "TaskDetailToStepDetail", sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as! StepDetailCell
        cell.step = steps?[indexPath.row]        
        if taskInstance?.getNextStep() == steps?[indexPath.row] {
            cell.nextStep = true
        }
        cell.loadCell()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps?.count ?? 0
    }
    
    func setAssigneeLoadedNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Step.allAssigneeLoadedNotification), object: nil, queue: OperationQueue.main, using: {(notification: Notification) -> Void in
            self.loadTopView()
            self.tableView.reloadData()
        })
    }
}

extension TaskDetailViewController: TaskInstanceUpdateDelegate {
    
    func taskInstanceUpdated() {
        if taskInstance!.getPercentComplete() >= 1.0 {
            taskInstance?.completed = true
        }            
        
        ParseClient.sharedInstance.updateTaskInstance(taskInstance: taskInstance!, success: { () -> () in
            self.tableView.reloadData()
            self.setPercentBarAndLabel()
            
            if self.taskInstance?.completed == true {
                self.notifyAllUsers()
            } else {
                self.notifyNextStepUsers()
            }
            
        }, failure: {(error) -> () in
            NSLog("error updating task: \(error)")
        })
    }
    
    func notifyNextStepUsers() {
        let nextStep = taskInstance?.getNextStep()
        
        for assignee in (nextStep?.assignees!)! {
            let message = "\(User.current!.name!) completed their task. You're up for \(nextStep!.name!)! May the force be with you."
            if assignee.email != User.current?.email {
                ParseClient.sharedInstance.sendPushTo(user: assignee, message: message)
            }
        }
    }
    
    func notifyAllUsers() {
        let users = taskInstance?.getInvolvedUsers()
        
        for user in users! {
            let message = "\(taskInstance!.name!) completed! Nice job."
            if user.email != User.current?.email {
                ParseClient.sharedInstance.sendPushTo(user: user, message: message)
            }
        }
    }
}

extension TaskDetailViewController: ActionViewProtocol {
    func actionViewRequestedAction(bottomBarViewController: BottomBarViewController) {
        performSegue(withIdentifier: "TaskDetailToChat", sender: self)
    }
    
    func imageForActionView() -> UIImage {
        return UIImage(named: "BarItemChat")!
    }
}
