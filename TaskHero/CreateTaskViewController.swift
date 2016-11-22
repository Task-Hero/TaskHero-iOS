//
//  CreateTaskViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionField: UITextView!
    @IBOutlet weak var taskDurationField: UITextField!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    fileprivate var taskDescriptionPlaceholderLabel: UILabel!
    
    var delegate: TaskCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDescriptionField.delegate = self
        taskDescriptionField.text = ""
        taskDescriptionField.textContainer.lineFragmentPadding = 0
        taskDescriptionField.textContainerInset = .zero
        
        initPlaceholderLabel()
        updateNextBarButtonItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateStepsViewController {
            vc.task = newTask()
        }
    }
    
    @IBAction func onNextTapped(_ sender: Any) {
        performSegue(withIdentifier: "CreateTaskToCreateSteps", sender: self)
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.resetNavigationStackToNewTask()
        }
    }
    
    @IBAction func taskNameDidChange(_ sender: Any) {
        updateNextBarButtonItem()
    }

    private func updateNextBarButtonItem() {
        nextBarButtonItem.isEnabled = !taskNameField.text!.isEmpty
    }
    
    private func newTask() -> Task {
        let task = Task()
        task.name = taskNameField.text
        task.details = taskDescriptionField.text
        
        if let duration = Double(taskDurationField.text ?? "") {
            task.estimatedTime = duration * 60  // TODO: time units
        }
        
        return task
    }
    
    private func resetNavigationStackToNewTask() {
        let root = self.storyboard?.instantiateViewController(withIdentifier: "CreateTaskViewController")
        self.navigationController?.viewControllers = [root!]
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderLabel()
    }
    
    fileprivate func initPlaceholderLabel() {
        taskDescriptionPlaceholderLabel = UILabel()
        taskDescriptionPlaceholderLabel.text = "Describe the task at a high level"
        taskDescriptionPlaceholderLabel.textColor = UIColor.lightGray
        taskDescriptionPlaceholderLabel.font = taskDescriptionField.font
        taskDescriptionPlaceholderLabel.sizeToFit()
        
        taskDescriptionField.addSubview(taskDescriptionPlaceholderLabel)
    }
    
    fileprivate func updatePlaceholderLabel() {
        taskDescriptionPlaceholderLabel.isHidden = !taskDescriptionField.text.isEmpty
    }
}
