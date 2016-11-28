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
    func taskLongPressed(_ taskCell:TaskCardCell)
}

class TaskCardCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    fileprivate var originalCenter:CGPoint!
    
    var delegate:TaskCardCellDelegate?
    
    var task:Task! {
        didSet{
            taskName.text = task.name
            taskDescription.text = task.details
            
            if let et = task.estimatedTime {
                estimatedTime.text = "\(et)"
            }
        }
    }
    
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
        
        let taskLongPress = UILongPressGestureRecognizer()
        taskLongPress.addTarget(self, action: #selector(onTaskLongPress))
        addGestureRecognizer(taskLongPress)
        
        let taskPan = UIPanGestureRecognizer()
        taskPan.addTarget(self, action: #selector(onTaskPan))
        addGestureRecognizer(taskPan)
    }
    
    @objc fileprivate func onTaskTap(sender: UITapGestureRecognizer) {
        delegate?.taskTapped(self)
    }
    
    @objc fileprivate func onTaskLongPress(sender: UILongPressGestureRecognizer) {
        delegate?.taskLongPressed(self)
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
                    self.center.x = self.center.x + (width / 2)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateBackToOriginalPosition() {
        UIView.animate(withDuration: 0.25, animations: {
            self.center.x = self.originalCenter.x
            self.alpha = 1
        })
    }
}
