//
//  EditStepTableViewCell.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

protocol EditStepCellDelegate {
    func stepCellWasRemoved(_ stepCell: EditStepCell)
    func stepCellCanBeRemoved(_ stepCell: EditStepCell) -> Bool
    func stepCellDidSelectAssignees(_ stepCell: EditStepCell)
}

class EditStepCell: UITableViewCell {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var assigneesLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    var delegate: EditStepCellDelegate?
    
    fileprivate var originalCenter: CGPoint!
    
    var step: Step! {
        didSet {
            nameField.text = step.name
            detailsField.text = step.details
            
            guard let assignees = step.assignees else {
                assigneesLabel.text = "None"
                return
            }
            
            guard !assignees.isEmpty else {
                assigneesLabel.text = "None"
                return
            }
            
            let names = assignees.map { $0.name ?? "" }
            assigneesLabel.text = names.joined(separator: ", ")
        }
    }
    
    fileprivate var canBeRemoved: Bool {
        get {
            return delegate?.stepCellCanBeRemoved(self) ?? true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        detailsField.delegate = self
        detailsField.isScrollEnabled = false
        detailsField.textContainer.lineFragmentPadding = 0
        detailsField.textContainerInset = .zero
        
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        assigneesLabel.isUserInteractionEnabled = true

        let assigneesTap = UITapGestureRecognizer()
        assigneesTap.addTarget(self, action: #selector(onAssigneesTap))
        assigneesLabel.addGestureRecognizer(assigneesTap)
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(onTap))
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(onPan))
        addGestureRecognizer(pan)
    }
    
    @IBAction func onNameChanged(_ sender: Any) {
        step.name = nameField.text
    }
    
    @objc fileprivate func onAssigneesTap(sender: UITapGestureRecognizer) {
        delegate?.stepCellDidSelectAssignees(self)
    }
    
    @objc fileprivate func onTap(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc fileprivate func onPan(sender: UIPanGestureRecognizer) {
        if !canBeRemoved {
            return
        }
        
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
                UIView.animate(
                    withDuration: 0.25,
                    animations: {
                        self.center.x = self.center.x + width
                        self.alpha = 0
                    },
                    completion: { (complete) in
                        self.delegate?.stepCellWasRemoved(self)
                    }
                )
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.center.x = self.originalCenter.x
                    self.alpha = 1
                }
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
}

extension EditStepCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        step.details = detailsField.text
    }
}
