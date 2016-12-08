//
//  CreateStepsViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class CreateStepsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addStepView: UIView!
    @IBOutlet weak var addStepImageView: UIImageView!
    
    var task: Task!
    fileprivate var selectedStep: Step!
    fileprivate var originalContentInset: UIEdgeInsets!

    var delegate: TaskCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        task.steps = []
        addNewStep(animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.registerNib(with: "EditStepCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onAddTapped))
        addStepView.layer.cornerRadius = addStepView.bounds.height / 2
        addStepView.addGestureRecognizer(tap)
        
        addStepImageView.tintColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.bottom += 20
        originalContentInset = tableView.contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(note: Notification) {
        let kbSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect)!.size
        
        var newInset = tableView.contentInset
        newInset.bottom += kbSize.height
        
        tableView.contentInset = newInset
        tableView.scrollIndicatorInsets = newInset
    }
    
    @objc fileprivate func keyboardWillHide(note: Notification) {
        if let originalContentInset = originalContentInset {
            tableView.contentInset = originalContentInset
            tableView.scrollIndicatorInsets = originalContentInset
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? UserPickerViewController {
                vc.delegate = self
            }
        }
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let destroyAction = UIAlertAction(title: "Discard", style: .destructive) { (action) in
            self.dismiss(animated: true) {
                self.resetNavigationStackToNewTask()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        ParseClient.sharedInstance.createTask(task: task, success: {() -> () in
            self.dismiss(animated: true) {
                BottomBar.instance.switchToRightViewController()
                self.resetNavigationStackToNewTask()
                self.delegate?.taskWasCreated(self.task)
            }
        }, failure: { (error) -> () in
            print(error)
        })
    }
    
    @objc fileprivate func onAddTapped(_ sender: UITapGestureRecognizer) {
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
    
    private func resetNavigationStackToNewTask() {
        let root = self.storyboard?.instantiateViewController(withIdentifier: "CreateTaskViewController")
        self.navigationController?.viewControllers = [root!]
    }
}

extension CreateStepsViewController: UITableViewDelegate {
}

extension CreateStepsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.steps?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditStepCell") as! EditStepCell
        cell.step = task.steps![indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension CreateStepsViewController: EditStepCellDelegate {
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
        performSegue(withIdentifier: "CreateStepsToPickUsers", sender: stepCell)
    }
}

extension CreateStepsViewController: UserPickerDelegate {
    func userPicker(_ userPicker: UserPickerViewController, didPick users: [User]) {
        selectedStep.assignees = users
        selectedStep = nil
        
        tableView.reloadData()
    }
}
