//
//  LoginInputViewController.swift
//  TaskHero
//
//  Created by Sahil Agarwal on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit
import Parse

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
        let bottomBarViewController = BottomBarLoader.loadBottomBar()
        self.present(bottomBarViewController, animated: true, completion: nil)
    }
}
