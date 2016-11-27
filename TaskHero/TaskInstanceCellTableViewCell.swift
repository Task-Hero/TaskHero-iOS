//
//  TaskInstanceCellTableViewCell.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/26/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskInstanceCellTableViewCell: UITableViewCell {

    var task: Task?
    var maxWidth: CGFloat?
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressViewContainer: UIView!
    @IBOutlet weak var progressView: UIView!
    
    var percentComplete: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        
        
        
    }
    
    func loadData() {
        progressViewContainer.layer.borderWidth = 2
        progressViewContainer.layer.borderColor = UIColor.black.cgColor
        percentComplete = round(getPercentComplete() * 100)
        percentLabel.text = "\(percentComplete!)%"
        taskNameLabel.text = task?.name
        progressConstraint.constant = getPercentCompleteWidth()
        loadImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadImage() {
        taskImageView.clipsToBounds = true
        taskImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        
        if percentComplete == 100 {
            taskImageView.image = UIImage(named: "Ok")
        } else {
            let lastStep = getLastCompletedStep()
            // TODO add multiple images if there's multiple assignees 
            if let assignee = lastStep?.assignees?[0] {
                let assigneeProfileUrl = assignee.profileImageUrl!
                taskImageView.setImageWith(assigneeProfileUrl)
            } else {
                taskImageView.image = UIImage(named: "QuesetionMark")
            }
        }
    }

    func getPercentCompleteWidth() -> CGFloat {
        let viewMaxWidth = maxWidth! - 20
        return (viewMaxWidth - (CGFloat(percentComplete!) * viewMaxWidth))
    }
    
    func getPercentComplete() -> Double {
        let total_steps = task?.steps?.count
        var completed_steps = 0.0
        
        for step in (task?.steps)! {
            
            if step.state == "Complete" {
                completed_steps += 1
            } else if step.state == "IP" {
                completed_steps += 0.25
            }
        }
        
        return completed_steps / Double(total_steps!)
    }
    
    func getLastCompletedStep() -> Step? {
        var last_completed_step_index = 0
        
        for (index, step) in (task?.steps)!.enumerated() {
            if step.state == "Complete" {
                last_completed_step_index = index
            }
        }
        
        return task?.steps?[last_completed_step_index]
    }
    
}
