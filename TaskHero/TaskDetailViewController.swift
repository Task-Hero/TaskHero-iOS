//
//  TaskDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    fileprivate let stepCellIdentifier = "StepCell"
    var currentSelectedCellRowNum = -1
    
    var steps:[Step]!
    var task:Task? {
        didSet{
            steps = task?.steps
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        taskName.text = task?.name
        taskDescription.text = task?.taskDescription
        estimatedTime.text = String(describing: (task?.estimatedTime)!)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: stepCellIdentifier, bundle: nil), forCellReuseIdentifier: stepCellIdentifier)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as! StepCell
        cell.step = steps?[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedCellRowNum = indexPath.row
        performSegue(withIdentifier: "TaskDetailToStepDetail", sender: nil) // send a task whihch selected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailToStepDetail" {
            let step = steps![currentSelectedCellRowNum]
            let stepDetailViewController = segue.destination as! StepDetailViewController
            stepDetailViewController.step = step
        }
    }
    
}
