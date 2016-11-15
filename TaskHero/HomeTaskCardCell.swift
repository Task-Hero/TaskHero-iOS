//
//  HomeTaskCardCell.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class HomeTaskCardCell: UITableViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentCompleteLabel: UILabel!
    @IBOutlet weak var lastCompletedStepLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    var task: Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData() {
        let roundedPercent = round(getPercentComplete() * 100)
        percentCompleteLabel.text = "\(roundedPercent)%"
        lastCompletedStepLabel.text = "Last completed: \(getLastCompletedStep().name!)"
        taskLabel.text = task?.name
        progressView.progress = Float(getPercentComplete())
    }
    
    func getPercentComplete() -> Double {
        let total_steps = task?.steps.count
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
    
    func getLastCompletedStep() -> Step {
        var last_completed_step_index = 0
        
        for (index, step) in (task?.steps)!.enumerated() {
            if step.state == "Complete" {
                last_completed_step_index = index
            }
        }
        
        return (task?.steps[last_completed_step_index])!
    }
    

}
