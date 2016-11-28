//
//  StepDetailCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class StepDetailCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var user1ImageView: UIImageView!
    @IBOutlet weak var user2ImageView: UIImageView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var stepNameLabel: UILabel!
    @IBOutlet weak var stepView: UIView!
    
    var nextStep: Bool = false
    
    var step: Step! {
        didSet {
            stepNameLabel.text = step.name
            user1ImageView.setImageWith((step.assignees?[0].profileImageUrl)!)
            if (step.assignees?.count)! > 1 {
                user2ImageView.setImageWith((step.assignees?[1].profileImageUrl)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepView.layer.borderWidth = 1
        stepView.layer.borderColor = UIColor.black.cgColor
        user1ImageView.clipsToBounds = true
        user1ImageView.layer.cornerRadius = user1ImageView.bounds.width / 2
        user2ImageView.clipsToBounds = true
        user2ImageView.layer.cornerRadius = user1ImageView.bounds.width / 2
        stateImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCell() {
        setStateImageView()
        let longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPressGesture(sender:)))
        cellView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func setStateImageView() {
        if step.state == StepState.completed {
            stateImageView.image = UIImage(named: "CheckMark")
        } else if nextStep {
            stateImageView.image = UIImage(named: "Attention")
        }
    }
    
    func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let bumpAction = UIAlertAction(title: "Bump", style: .default) { (action) in
                self.sendBump()
            }
            let completeAction = UIAlertAction(title: "Mark Complete", style: .default) { (action) in
                print("complete")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(bumpAction)
            alertController.addAction(completeAction)
            parentViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sendBump() {
        if step.state != StepState.completed {
            for assignee in step.assignees! {
                let message = "\(User.current!.name!) sent you a bump to complete: \"\(step.name!)\""
                ParseClient.sharedInstance.sendPushTo(user: assignee, message: message)
            }
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.1
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: stepView.center.x - 7, y: stepView.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: stepView.center.x + 7, y: stepView.center.y))
            stepView.layer.add(animation, forKey: "position")
        }
    }
    
    func completeStep() {
        step.state = StepState.completed
    }

}
