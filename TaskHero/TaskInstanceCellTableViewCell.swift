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
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressViewContainer: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    var percentComplete: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadViews() {
        selectionStyle = .none
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        progressViewContainer.layer.cornerRadius = 10
        progressViewContainer.layer.borderWidth = 2
        progressViewContainer.layer.borderColor = AppColors.appBlue.cgColor
        progressViewContainer.clipsToBounds = true
        
        progressView.layer.backgroundColor = AppColors.appBlue.cgColor
    }
    
    func loadData() {
        loadViews()
        percentComplete = round((task?.getPercentComplete())! * 100)
        taskNameLabel.text = task?.name
        taskNameLabel.textColor = AppColors.appBlack
        dateLabel.text = task?.updatedAt
        progressConstraint.constant = getPercentCompleteWidth()
        percentLabel.text = "\(percentComplete!)%"
        percentLabel.textColor = AppColors.appBlack
        loadImage()
    }
    
    func loadImage() {
        taskImageView.clipsToBounds = true
        taskImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        secondImageView.isHidden = true
        secondImageView.clipsToBounds = true
        secondImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        taskImageTopConstraint.constant = 12
        taskImageLeadingConstraint.constant = 12
        secondImageViewWidthConstraint.constant = 40
        progressViewContainer.layer.backgroundColor = AppColors.appWhite.cgColor
        
        if percentComplete == 100 {
            taskImageView.image = UIImage(named: "StepIconChecked")
            taskImageViewHeightConstraint.constant = 45
            taskImageViewWidthConstraint.constant = 45
            taskImageTopConstraint.constant = 8
            taskImageLeadingConstraint.constant = 8
            secondImageViewWidthConstraint.constant = 0
            progressView.layer.backgroundColor = AppColors.appGreen.cgColor
        } else {
            let lastStep = task?.getNextStep()
            if let assignees = lastStep?.assignees {
                let assigneeProfileUrl = assignees[0].profileImageUrl!
                taskImageView.setImageWith(assigneeProfileUrl)
                if assignees.count > 1 {
                    secondImageView.isHidden = false
                    let assigneeProfileUrl = assignees[1].profileImageUrl!
                    secondImageView.setImageWith(assigneeProfileUrl)
                } else {
                    secondImageViewWidthConstraint.constant = 0
                }
                
                for assignee in assignees {
                    if assignee.email == User.current?.email {
                        progressViewContainer.layer.backgroundColor = AppColors.appMidGrey.cgColor
                    }
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
