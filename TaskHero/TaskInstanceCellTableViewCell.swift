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
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var TaskImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var TaskImageViewTrailingConstraint: NSLayoutConstraint!
    
    var percentComplete: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadViews() {
        selectionStyle = .none
        cardView.layer.cornerRadius = 8.0
        
        progressViewContainer.layer.cornerRadius = 25
        progressViewContainer.layer.borderWidth = 2
        progressViewContainer.layer.borderColor = AppColors.appBlue.cgColor
        progressViewContainer.clipsToBounds = true
        
        progressView.layer.backgroundColor = AppColors.appBlue.cgColor
    }
    
    func loadPercentLabelTextColors() {
        percentLabel.textColor = AppColors.appBlack
        
        if progressView.frame.maxX > percentLabel.frame.maxX {
            print("\(progressView.frame.maxX)")
            print("\(percentLabel.frame.maxX)")
            percentLabel.textColor = AppColors.appWhite
        }
        
        let myMutableString = NSMutableAttributedString(string: "\(percentComplete!)%", attributes: nil)
        //TODO: find the x value of each character and set only that portion to be white
        //myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0,length:2))
        percentLabel.attributedText = myMutableString
    }
    
    func loadData() {
        loadViews()
        percentComplete = round((task?.getPercentComplete())! * 100)
        taskNameLabel.text = task?.name
        progressConstraint.constant = getPercentCompleteWidth()
        loadImage()
        loadPercentLabelTextColors()
    }
    
    func loadImage() {
        taskImageView.clipsToBounds = true
        taskImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        secondImageView.isHidden = true
        secondImageView.clipsToBounds = true
        secondImageView.layer.cornerRadius = taskImageView.bounds.width / 2
        
        if percentComplete == 100 {
            taskImageView.image = UIImage(named: "TaskIconChecked")
            taskImageViewHeightConstraint.constant = 50
            TaskImageViewWidthConstraint.constant = 50
            TaskImageViewTrailingConstraint.constant = 2
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
