//
//  TaskDetailTaskCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/29/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskDetailTaskCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDetailLabel: UILabel!
    @IBOutlet weak var taskEstimatedTimeLabel: UILabel!
    
    var task:Task! {
        didSet{
            taskNameLabel.text = task.name
            taskDetailLabel.text = task.details
            
            if let et = task.estimatedTime {
                taskEstimatedTimeLabel.text = "\(et)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
