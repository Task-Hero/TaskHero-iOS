//
//  PopoverView.swift
//  TaskHero
//
//  Created by Jonathan Como on 12/4/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

protocol PopoverViewDelegate: class {
    func popoverViewDidSelectPrimaryAction(popoverView: PopoverView)
    func popoverViewDidSelectSecondaryAction(popoverView: PopoverView)
}

class PopoverView: UIView {

    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: PopoverViewDelegate?
    
    var primaryTitle: String! {
        didSet {
            primaryButton.setTitle(primaryTitle.uppercased(), for: .normal)
        }
    }
    
    var secondaryTitle: String! {
        didSet {
            secondaryButton.setTitle(secondaryTitle.uppercased(), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.clipsToBounds = true
        
        roundOffButton(primaryButton)
        roundOffButton(secondaryButton)
        
        secondaryButton.layer.borderWidth = 4.0
        secondaryButton.layer.borderColor = secondaryButton.titleLabel?.textColor.cgColor
    }
    
    private func roundOffButton(_ button: UIButton) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.clipsToBounds = true
    }
    
    @IBAction func onPrimary(_ sender: UIButton) {
        delegate?.popoverViewDidSelectPrimaryAction(popoverView: self)
    }
    
    @IBAction func onSecondary(_ sender: UIButton) {
        delegate?.popoverViewDidSelectSecondaryAction(popoverView: self)
    }
}
