//
//  TaskCardCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

protocol TaskCardCellDelegate {
//    func taskCellWasRemoved(_ taskCell:TaskCardCell)
    func taskTapped(_ taskCell:TaskCardCell)
    func taskLongPressed(_ taskCell:TaskCardCell)
}

class TaskCardCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    var delegate:TaskCardCellDelegate?
    
    var task:Task! {
        didSet{
            taskName.text = task.name
            taskDescription.text = task.details
            estimatedTime.text = "\(task.estimatedTime!)"
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
        print("---- on TaskTapped")
        delegate?.taskTapped(self)
    }
    
    @objc fileprivate func onTaskLongPress(sender: UILongPressGestureRecognizer) {
        print("---- on LongPress")
        delegate?.taskLongPressed(self)
    }
    
    @objc fileprivate func onTaskPan(sender: UIPanGestureRecognizer) {
        print("---- on Pan")
        // TODO: add delete task functionality here.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
