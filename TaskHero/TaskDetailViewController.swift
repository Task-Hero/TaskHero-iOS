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
    
    var taskInstance: TaskInstance? {
        didSet {
            steps = taskInstance?.steps
        }
    }
    var steps: [Step]!
    var selectedCell: Int?
    let stepCellIdentifier = "StepDetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        loadTopView()
        loadTableView()
        tableView.reloadData()
    }
    
    func loadTopView() {
        taskNameLabel.text = (taskInstance!.name!)
        taskDescriptionLabel.text = taskInstance?.details
        setUserImages(users: (taskInstance?.getInvolvedUsers())!)
        setPercentBarAndLabel()
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
        let viewMaxWidth = progressBarContainerView.frame.width
        progressBarTrailingConstraint.constant = (viewMaxWidth - (CGFloat(percentComplete) / 100 * viewMaxWidth))
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StepDetailViewController {
            vc.step = steps![selectedCell!]
        } else if let vc = segue.destination as? ChatViewController {
            vc.task = taskInstance
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
    
}

extension TaskDetailViewController: TaskInstanceUpdateDelegate {
    
    func taskInstanceUpdated() {
        ParseClient.sharedInstance.updateTaskInstance(taskInstance: taskInstance!, success: { () -> () in
            self.tableView.reloadData()
            self.setPercentBarAndLabel()
        }, failure: {(error) -> () in
            NSLog("error updating task: \(error)")
        })
    }
    
}

