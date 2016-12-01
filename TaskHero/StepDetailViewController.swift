//
//  StepDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class StepDetailViewController: UIViewController {

    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var dateStarted: UILabel!
    @IBOutlet weak var dateUpdated: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    var step: Step!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepName.text = step.name
        stepDescription.text = step.details
        setUserImages()
        setStateImageView()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUserImages() {
        let imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
        for (index, user) in (step.assignees?.enumerated())! {
            if index > 4 {
                break
            }
            imageViewArray[index]?.setImageWith(user.profileImageUrl)
            imageViewArray[index]?.clipsToBounds = true
            imageViewArray[index]?.layer.cornerRadius = (imageViewArray[index]?.bounds.width)! / 2
        }
    }
    
    func setStateImageView() {
        if step.state == StepState.completed {
            statusImageView.image = UIImage(named: "CheckMark")
        } else {
            statusImageView.image = UIImage(named: "Attention")
        }
    }
    
}

