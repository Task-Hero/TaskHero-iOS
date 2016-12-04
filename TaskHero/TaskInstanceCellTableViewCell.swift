//
//  TaskInstanceCellTableViewCell.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/26/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskInstanceCellTableViewCell: UITableViewCell {

    var task: TaskInstance?
    var maxWidth: CGFloat?
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressViewContainer: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    
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
        percentComplete = round((task?.getPercentComplete())! * 100)
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
        secondImageView.isHidden = true
        secondImageView.clipsToBounds = true
        secondImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        
        if percentComplete == 100 {
            taskImageView.image = UIImage(named: "CheckMark")
        } else {
            let lastStep = task?.getNextStep()
            if let assignees = lastStep?.assignees {
                let assigneeProfileUrl = assignees[0].profileImageUrl!
                taskImageView.setImageWith(assigneeProfileUrl)
                if assignees.count > 1 {
                    secondImageView.isHidden = false
                    let assigneeProfileUrl = assignees[1].profileImageUrl!
                    secondImageView.setImageWith(assigneeProfileUrl)
                }
            } else {
                taskImageView.image = UIImage(named: "QuestionMark")
            }
        }
    }

    func getPercentCompleteWidth() -> CGFloat {
        let viewMaxWidth = maxWidth! - 20
        return (viewMaxWidth - (CGFloat(percentComplete!) / 100 * viewMaxWidth))
    }
    
}
