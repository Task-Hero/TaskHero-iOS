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
        stepDescription.text = step.stepDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
