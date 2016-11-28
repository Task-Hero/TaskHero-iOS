//
//  StepCell.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var user1ImageView: UIImageView!
    @IBOutlet weak var user2ImageView: UIImageView!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var stepNameLabel: UILabel!
    @IBOutlet weak var stepView: UIView!
    
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
        // Initialization code
        stepView.layer.borderWidth = 1
        stepView.layer.borderColor = UIColor.black.cgColor
        
        user1ImageView.clipsToBounds = true
        user1ImageView.layer.cornerRadius = user1ImageView.bounds.width / 2
        user2ImageView.clipsToBounds = true
        user2ImageView.layer.cornerRadius = user1ImageView.bounds.width / 2
        stateImageView.clipsToBounds = true
        stateImageView.layer.cornerRadius = user1ImageView.bounds.width / 2        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
