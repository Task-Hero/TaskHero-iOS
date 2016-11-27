//
//  TaskCatalogDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/26/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class TaskCatalogDetailViewController: UIViewController {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDetail: UILabel!
    @IBOutlet weak var taskEstimatedTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let stepCellIdentifier = "EditStepCell"
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
        taskDetail.text = task?.details
        taskEstimatedTime.text = String(describing: (task?.estimatedTime)!)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(UINib(nibName: stepCellIdentifier, bundle: nil), forCellReuseIdentifier: stepCellIdentifier)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension TaskCatalogDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedCellRowNum = indexPath.row
        performSegue(withIdentifier: "TaskCatalogToTaslCatalogDetail", sender: nil)
    }
}

extension TaskCatalogDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepCellIdentifier, for: indexPath) as! EditStepCell
        cell.step = steps?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps?.count ?? 0
    }
}
