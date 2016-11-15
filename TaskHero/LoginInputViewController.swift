//
//  LoginInputViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class LoginInputViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage.init(named: "loginBackground")
        loadButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateBackground()
    }
    
    func animateBackground() {
        UIView.animate(withDuration: 12.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.transform = CGAffineTransform(scaleX: 2.5,y: 2.5)
        }, completion: nil)
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadButtons() {
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 6
    }
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        if (email == "" || password == "") {
            showAlert(message: "Username and Password can't be empty")
            return;
        }

        ParseClient.sharedInstance.signup(
            name: "Test User",
            email: email,
            password: password,
            success: { (user) in
                self.transitionToApp()
            },
            failure: { (error) in
                ParseClient.sharedInstance.login(
                    email: email,
                    password: password,
                    success: { (user) in
                        self.transitionToApp()
                    }, failure: { (error) in
                        print("Invalid credentials...we should do something about this later")
                    }
                )
            }
        )
    }
    
    private func transitionToApp() {
        let bottomBarViewController = BottomBarLoader.loadBottomBar()
        self.present(bottomBarViewController, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay.", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
