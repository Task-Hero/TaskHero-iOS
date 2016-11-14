//
//  TaskCardCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCardCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    var task:Task! {
        didSet{
            taskName.text = task.name
            taskDescription.text = task.taskDescription
            estimatedTime.text = String(task.estimatedTime)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
