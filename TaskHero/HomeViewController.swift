//
//  HomeViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/14/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
        loadNavigationBar()

    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        ParseClient.logout()
    }
    
    func loadNavigationBar() {
        title = User.currentUser?.name
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTaskCardCell", for: indexPath) as! HomeTaskCardCell
        cell.textLabel?.text = "YA"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
