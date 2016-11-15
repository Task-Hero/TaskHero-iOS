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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        backgroundImageView.transform = CGAffineTransform(scaleX: 1,y: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateBackground()
    }
    
    func animateBackground() {
        UIView.animate(withDuration: 12.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.transform = CGAffineTransform(scaleX: 2.5,y: 2.5)
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
}
