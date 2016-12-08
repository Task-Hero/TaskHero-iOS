//
//  TaskDetailTaskCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/29/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit


protocol TaskDetailTaskCellDelegate {
    func taskDetailCellWasUpdated(_ updatedTask: Task)
}


class TaskDetailTaskCell: UITableViewCell {

    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDetailTextView: UITextView!
    @IBOutlet weak var taskEstimatedField: UITextField!
    
    var delegate: TaskDetailTaskCellDelegate?
    
    var task:Task! {
        didSet{
            taskNameField.text = task.name
            taskDetailTextView.text = task.details
            
            if let et = task.estimatedTime {
                taskEstimatedField.text = "\(et)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskDetailTextView.delegate = self
        taskDetailTextView.isScrollEnabled = false
        taskDetailTextView.textContainer.lineFragmentPadding = 0
        taskDetailTextView.textContainerInset = .zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onNameUpdated(_ sender: Any) {
        task.name = taskNameField.text
        delegate?.taskDetailCellWasUpdated(task)
    }
    @IBAction func estimatedTimeUpdated(_ sender: Any) {
        if let estimatedTime = Double(taskEstimatedField.text ?? "") {
            task.estimatedTime = estimatedTime * 60
        }
        delegate?.taskDetailCellWasUpdated(task)
    }
}

extension TaskDetailTaskCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        task.details = taskDetailTextView.text
        delegate?.taskDetailCellWasUpdated(task)
    }
}
