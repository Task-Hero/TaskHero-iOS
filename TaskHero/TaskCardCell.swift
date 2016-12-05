//
//  TaskCardCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

protocol TaskCardCellDelegate {
    func taskCellWasRemoved(_ taskCell:TaskCardCell)
    func taskTapped(_ taskCell:TaskCardCell)
}

class TaskCardCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    @IBOutlet weak var memberIcon1: UIImageView!
    @IBOutlet weak var memberIcon2: UIImageView!
    @IBOutlet weak var memberIcon3: UIImageView!
    @IBOutlet weak var memberIcon4: UIImageView!
    @IBOutlet weak var memberIcon5: UIImageView!
    @IBOutlet weak var memberIcon6: UIImageView!
    @IBOutlet weak var memberIcon7: UIImageView!
    
    var iconImageViews:[UIImageView]?
    
    fileprivate var originalCenter:CGPoint!
    
    var delegate:TaskCardCellDelegate?
    
    var task:Task! {
        didSet{
            taskName.text = task.name
            taskDescription.text = task.details
            
            if let et = task.estimatedTime {
                estimatedTime.text = "\(et)"
            }
            
            if isAssigneeLoaded {
                setMemberIcons(users: task.getInvolvedUsers())
            }
        }
    }
    var isAssigneeLoaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        let taskTap = UITapGestureRecognizer()
        taskTap.addTarget(self, action: #selector(onTaskTap))
        addGestureRecognizer(taskTap)
        
        let taskPan = UIPanGestureRecognizer()
        taskPan.addTarget(self, action: #selector(onTaskPan))
        taskPan.delegate = self
        addGestureRecognizer(taskPan)
        
        iconImageViews = [memberIcon1, memberIcon2, memberIcon3, memberIcon4, memberIcon5, memberIcon6, memberIcon7]
        for iconImageView in iconImageViews! {
            iconImageView.isHidden = true
            iconImageView.clipsToBounds = true
            iconImageView.layer.cornerRadius = iconImageView.bounds.width / 2
        }


    }
    
    @objc fileprivate func onTaskTap(sender: UITapGestureRecognizer) {
        delegate?.taskTapped(self)
    }
    
    @objc fileprivate func onTaskPan(sender: UIPanGestureRecognizer) {
        let width = bounds.size.width
        let translation = sender.translation(in: self)
        let velocity = sender.velocity(in: self)
        
        if sender.state == .began {
            originalCenter = center
        } else if sender.state == .changed {
            center.x = originalCenter.x + max(0, translation.x)
            alpha = 1 - (translation.x / width)
        } else if sender.state == .ended {
            if translation.x > (width / 2) && velocity.x > 0 {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.center.x = self.center.x + width
                    self.alpha = 0
                }, completion: {(complete) in
                    self.delegate?.taskCellWasRemoved(self)
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.center.x = self.originalCenter.x
                    self.alpha = 1
                })
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: self)
            return fabs(velocity.x) > fabs(velocity.y)
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateBackToOriginalPosition() {
        UIView.animate(withDuration: 0.25, animations: {
            self.center.x = self.originalCenter.x
            self.alpha = 1
        })
    }

    fileprivate func setMemberIcons(users: [User]) {
        for (index, imageView) in (iconImageViews?.enumerated())! {
            if index < (users.count) {
                imageView.isHidden = false
                let user = users[index]
                imageView.setImageWith(user.profileImageUrl)
            } else {
                imageView.isHidden = true
            }
        }
    }
}
