//
//  LoginViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appnameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage.init(named: "loginBackground")
        logoImageView.image = UIImage.init(named: "logo")
        loadButtons()
        animateBackground()
    }
    
    func logoutNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.animateBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func animateBackground() {
        UIView.animate(withDuration: 12.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.transform = CGAffineTransform(scaleX: 3,y: 3)
        }, completion: nil)
    }
    
    func loadButtons() {
        signupButton.backgroundColor = UIColor.clear
        loginButton.backgroundColor = UIColor.clear
        
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.cornerRadius = 6
        
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 6
    }

    // TODO: (sahil) change appropriately
    @IBAction func onSignupButton(_ sender: Any) {
        ParseClient.getUser(email: "taskheroapp@gmail.com", success: {(user: User) -> () in
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
