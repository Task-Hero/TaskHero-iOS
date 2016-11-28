//
//  LoginViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appLogoLabel: UILabel!
    @IBOutlet weak var appLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var appnameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfigs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userInputView.isHidden = true
    }
    
    func buttonConfigs() {
        signupButton.backgroundColor = UIColor.clear
        loginButton.backgroundColor = UIColor.clear
        okButton.backgroundColor = UIColor.clear
        
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.cornerRadius = 6
        
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 6
        
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.layer.cornerRadius = 6
    }
    
    @IBAction func onLoginTouch(_ sender: Any) {
        animateInputFields()
        usernameField.becomeFirstResponder()
    }
    
    private func animateInputFields() {
        self.appLogoTopConstraint.constant = 10
        
        UIView.animate(withDuration: 0.4, animations: {
            self.userInputView.alpha = 1
            self.buttonsView.alpha = 0.1
            self.appnameLabel.alpha = 0.1
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.userInputView.isHidden = false
            self.buttonsView.isHidden = true
            self.appnameLabel.isHidden = true
        })
    }
    
    @IBAction func onSignupTouch(_ sender: Any) {        
        ParseClient.sharedInstance.login(
            email: "taskheroapp@gmail.com",
            password: "admin",
            success: { (user) in
                self.transitionToApp()
        }, failure: { (error) in
            self.showAlert(message: "Username or Password is not valid")
        })
    }
    
    @IBAction func onOkTouch(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        if (username == "" || password == "") {
            showAlert(message: "Username and Password can't be empty")
            return;
        }
        
        ParseClient.sharedInstance.login(
            email: username,
            password: password,
            success: { (user) in
                self.transitionToApp()
        }, failure: { (error) in
            self.view.endEditing(true)
            self.showAlert(message: "Username or Password is not valid")
            self.animateLoginSignupButtons()
        })
    }
    
    private func animateLoginSignupButtons() {
        appLogoTopConstraint.constant = 120
        
        UIView.animate(withDuration: 0.3, animations: {
            self.userInputView.alpha = 0.1
            self.buttonsView.alpha = 1
            self.appnameLabel.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.userInputView.isHidden = true
            self.buttonsView.isHidden = false
            self.appnameLabel.isHidden = false
        })        
    }
    
    private func transitionToApp() {
        ParseClient.sharedInstance.connectCurrentUserAndInstallation()
        let bottomBarViewController = BottomBarLoader.loadBottomBar()
        self.present(bottomBarViewController, animated: true, completion: nil)
    }
    
}
