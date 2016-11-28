//
//  TaskCatalogDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/26/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCatalogDetailViewController: UIViewController {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDetail: UILabel!
    @IBOutlet weak var taskEstimatedTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var selectedStep: Step!
    fileprivate let stepCellIdentifier = "EditStepCell"
    var currentSelectedCellRowNum = -1
    
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.text = task?.name
        taskDetail.text = task?.details
        taskEstimatedTime.text = String(describing: (task?.estimatedTime)!)
        
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
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
            let nextIndex = IndexPath(row: task.steps!.count - 1, section: 0)
            tableView.insertRows(at: [nextIndex], with: .right)
            tableView.endUpdates()
            
            tableView.scrollToRow(at: nextIndex, at: .bottom, animated: true)
        }
    }
    
    fileprivate func removeStep(at indexPath: IndexPath) {
        task.steps?.remove(at: indexPath.row)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as! EditStepCell
        cell.step = task.steps?[indexPath.row]
        cell.delegate = self
        cell.isTaskDetailFlow = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.steps?.count ?? 0
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
        selectedStep = task.steps![indexPath!.row]
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




