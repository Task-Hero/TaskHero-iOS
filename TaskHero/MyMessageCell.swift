//
//  MyMessageCell.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var message: Message! {
        didSet {
            messageTextLabel.text = message.text
            
            if let profileImageUrl = message.author?.profileImageUrl {
                profileImageView.setImageWith(profileImageUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.height / 2
        
        messageView.clipsToBounds = true
        messageView.layer.cornerRadius = 4.0
    }
}
