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
    
    var step:Step!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepName.text = step.name
        stepDescription.text = step.details
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

