//
//  UserPickerViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import THContactPicker

protocol UserPickerDelegate {
    func userPicker(_ userPicker: UserPickerViewController, didPick users: [User])
}

class UserPickerViewController: UIViewController {
    
    @IBOutlet weak var contactPickerView: THContactPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var users: [User]?
    fileprivate var filteredUsers: [User]?
    fileprivate var selectedUsers: [User]?
    
    var delegate: UserPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(with: "UserPickerCell")
        
        contactPickerView.delegate = self
        contactPickerView.setPlaceholderLabelText("Who is assigned?")
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        ParseClient.sharedInstance.getTeammates(
            success: { (users) in
                self.users = users
                self.filteredUsers = users
                self.selectedUsers = []
                self.tableView.reloadData()
            },
            failure: { (error) in
                print("ERROR - failed to fetch users")
            }
        )
    }
    
    fileprivate func filterUsers(constraint: String) {
        if constraint.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users?.filter({ (user) -> Bool in
                return user.name?.lowercased().contains(constraint.lowercased()) ?? false
            })
        }
        
        tableView.reloadData()
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        delegate?.userPicker(self, didPick: selectedUsers ?? [])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = filteredUsers![indexPath.row]
        
        if let index = selectedUsers?.index(of: user) {
            selectedUsers?.remove(at: index)
            contactPickerView.removeContact(user)
        } else {
            selectedUsers?.append(user)
            contactPickerView.addContact(user, withName: user.name)
        }
        
        filterUsers(constraint: "")
    }
}

extension UserPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPickerCell") as! UserPickerCell
        let user = filteredUsers![indexPath.row]
        let selected = selectedUsers?.contains(user) ?? false
        
        cell.user = user
        cell.accessoryType = selected ? .checkmark : .none
        
        return cell
    }
}

extension UserPickerViewController: THContactPickerDelegate {
    func contactPicker(_ contactPicker: THContactPickerView!, textFieldDidChange textField: UITextField!) {
        filterUsers(constraint: textField.text ?? "")
    }
    
    func contactPicker(_ contactPicker: THContactPickerView!, didRemoveContact contact: Any!) {
        if let index = selectedUsers?.index(of: contact as! User) {
            selectedUsers?.remove(at: index)
            tableView.reloadData()
        }
        
    }
}
