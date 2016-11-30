//
//  TaskCatalogDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/26/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCatalogDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var selectedStep: Step!
    fileprivate let taskCellIdentifier = "TaskDetailTaskCell"
    fileprivate let stepCellIdentifier = "EditStepCell"
    var currentSelectedCellRowNum = -1
    
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.registerNib(with: taskCellIdentifier)
        tableView.registerNib(with: stepCellIdentifier)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        ParseClient.sharedInstance.updateTask(task: task, success: {}, failure: {error in print(error) })
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        addNewStep(animated: true)
    }
    
    private func addNewStep(animated: Bool) {
        task.steps!.append(Step())
        
        if !animated {
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            let nextIndex = IndexPath(row: task.steps!.count, section: 0)
            tableView.insertRows(at: [nextIndex], with: .right)
            tableView.endUpdates()
            
            tableView.scrollToRow(at: nextIndex, at: .bottom, animated: true)
        }
    }
    
    fileprivate func removeStep(at indexPath: IndexPath) {
        task.steps?.remove(at: indexPath.row - 1)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? UserPickerViewController {
                vc.delegate = self
            }
        }
    }
}

extension TaskCatalogDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier, for: indexPath) as! TaskDetailTaskCell
            cell.task = self.task
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as! EditStepCell
            cell.step = task.steps?[indexPath.row - 1]
            cell.delegate = self
            cell.isTaskDetailFlow = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (task.steps?.count)! + 1 
    }
}

extension TaskCatalogDetailViewController: EditStepCellDelegate {
    func stepCellWasRemoved(_ stepCell: EditStepCell) {
        let removedIndexPath = tableView.indexPath(for: stepCell)
        removeStep(at: removedIndexPath!)
    }
    
    func stepCellCanBeRemoved(_ stepCell: EditStepCell) -> Bool {
        return (task.steps?.count ?? 0) > 1
    }
    
    func stepCellDidSelectAssignees(_ stepCell: EditStepCell) {
        let indexPath = tableView.indexPath(for: stepCell)
        selectedStep = task.steps![indexPath!.row - 1]
        performSegue(withIdentifier: "TaskCatalogDetailoPickUsers", sender: stepCell)
    }
}

extension TaskCatalogDetailViewController: UserPickerDelegate {
    func userPicker(_ userPicker: UserPickerViewController, didPick users: [User]) {
        selectedStep.assignees = users
        selectedStep = nil
        
        tableView.reloadData()
    }
}




