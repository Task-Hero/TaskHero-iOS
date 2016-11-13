//
//  BottomBarViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class BottomBarViewController: UIViewController {

    @IBOutlet weak var leftBarItemImageView: UIImageView!
    @IBOutlet weak var rightBarItemImageView: UIImageView!
    @IBOutlet weak var actionBarItemImageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    
    var leftItemViewController: UIViewController! {
        didSet {
            if let imageView = leftBarItemImageView {
                imageView.image = leftItemViewController.tabBarItem.image
            }
        }
    }
    
    var rightItemViewController: UIViewController! {
        didSet {
            if let imageView = rightBarItemImageView {
                imageView.image = rightItemViewController.tabBarItem.image
            }
        }
    }
    
    var actionViewController: UIViewController! {
        didSet {
            if let imageView = actionBarItemImageView {
                imageView.image = actionViewController.tabBarItem.image
            }
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            updateSelection()

            if oldContentViewController != nil {
                if contentViewController == oldContentViewController {
                    return
                }
                
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.removeFromParentViewController()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            view.layoutIfNeeded()
            
            contentViewController.willMove(toParentViewController: self)
            addChildViewController(contentViewController)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBarItemImageView.image = leftItemViewController.tabBarItem.image
        rightBarItemImageView.image = rightItemViewController.tabBarItem.image
        actionBarItemImageView.image = actionViewController.tabBarItem.image
        
        contentViewController = leftItemViewController
    }
    
    @IBAction func onActionItemTapped(_ sender: UITapGestureRecognizer) {
        present(actionViewController, animated: true, completion: nil)
    }
    
    @IBAction func onBarItemTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == leftBarItemImageView {
            contentViewController = leftItemViewController
        } else if sender.view == rightBarItemImageView {
            contentViewController = rightItemViewController
        }
    }
    
    private func updateSelection() {
        leftBarItemImageView.tintColor = UIColor.black
        rightBarItemImageView.tintColor = UIColor.black
        
        if contentViewController == leftItemViewController {
            leftBarItemImageView.tintColor = UIColor.red
        } else if contentViewController == rightItemViewController {
            rightBarItemImageView.tintColor = UIColor.red
        }
    }
}
