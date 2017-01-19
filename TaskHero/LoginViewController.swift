//
//  LoginViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appLogoImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var appLogoImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var appLogoImageViewWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonConfigs()
        backgroundImageView.backgroundColor = AppColors.appWhite
        appLogoImageView.image = UIImage(named: "appLogo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userInputView.isHidden = true
    }
    
    func buttonConfigs() {
        signupButton.backgroundColor = UIColor.clear
        loginButton.backgroundColor = UIColor.clear
        okButton.backgroundColor = UIColor.clear
        
        signupButton.tintColor = AppColors.appRed
        loginButton.tintColor = AppColors.appRed
        okButton.tintColor = AppColors.appRed
        
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.borderColor = AppColors.appBlue.cgColor
        signupButton.layer.cornerRadius = 6
        
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = AppColors.appBlue.cgColor
        loginButton.layer.cornerRadius = 6
        
        okButton.layer.borderWidth = 2.0
        okButton.layer.borderColor = AppColors.appBlue.cgColor
        okButton.layer.cornerRadius = 6
    }
    
    @IBAction func onLoginTouch(_ sender: Any) {
        animateInputFields()
        usernameField.becomeFirstResponder()
    }
    
    private func animateInputFields() {
        self.appLogoImageViewTopConstraint.constant = 50
        self.appLogoImageViewHeight.constant = 130
        self.appLogoImageViewWidth.constant = 130
        
        UIView.animate(withDuration: 0.4, animations: {
            self.userInputView.alpha = 1
            self.buttonsView.alpha = 0.1
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.userInputView.isHidden = false
            self.buttonsView.isHidden = true
        })
    }
    
    @IBAction func onSignupTouch(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
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
        appLogoImageViewTopConstraint.constant = 90
        self.appLogoImageViewHeight.constant = 200
        self.appLogoImageViewWidth.constant = 200
        
        UIView.animate(withDuration: 0.3, animations: {
            self.userInputView.alpha = 0.1
            self.buttonsView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            self.userInputView.isHidden = true
            self.buttonsView.isHidden = false
        })        
    }
    
    private func transitionToApp() {
        UIView.animate(withDuration: 1.5, animations: ({
            self.userInputView.isHidden = true
            self.buttonsView.isHidden = true
            self.appLogoImageView.transform = CGAffineTransform(scaleX: 25,y: 25)
        }), completion: ({ finish in
            ParseClient.sharedInstance.connectCurrentUserAndInstallation()
            self.present(BottomBar.instance, animated: true, completion: nil)
        }))
    }
    
}
