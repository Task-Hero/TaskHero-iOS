//
//  SignupViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 1/12/17.
//  Copyright © 2017 Task Hero. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var teamField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfigs()
        appLogoImageView.image = UIImage(named: "appLogo")
        emailField.becomeFirstResponder()
    }
    
    func buttonConfigs() {
        okButton.backgroundColor = UIColor.clear
        okButton.tintColor = AppColors.appRed
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = AppColors.appBlue.cgColor
        okButton.layer.cornerRadius = 6
    }
    
    @IBAction func onOkButton(_ sender: Any) {
        let username = emailField.text!
        let name = NameField.text!
        let team = teamField.text!
        let password = passwordField.text!
        
        if (username == "" || name == "" || team == "" || password == "") {
            showAlert(message: "Username, Name, Team, and Password fields must all be filled")
            return;
        } else {
            
            ParseClient.sharedInstance.signup(name: name, email: username, team: team, password: password, success: { (user) in
                // Log into the app
            }, failure: { (error) in
                self.view.endEditing(true)
                self.showAlert(message: "Username is not valid")
            })
        }
    }
    
}
