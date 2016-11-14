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
        animateBackground()
        loadButtons()
    }
    
    func animateBackground() {
        UIView.animate(withDuration: 12.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.transform = CGAffineTransform(scaleX: 3,y: 3)
        }, completion: nil)
    }
    
    func loadButtons() {
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 6
    }

    @IBAction func onLoginButton(_ sender: UIButton) {
        
        if (emailTextField.text == "" || passwordTextField.text == "") {
            showAlert()
            return;
        } else {
            ParseClient.getUser(email: emailTextField.text!, success: {(user: User) -> () in
                User.currentUser = user
                let bottomBarViewController = BottomBarLoader.loadBottomBar()
                self.present(bottomBarViewController, animated: true, completion: nil)
                return;
            }, failure: {() -> () in
                print("failed")
                return;
            })
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Username and Password can't be empty.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay.", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
