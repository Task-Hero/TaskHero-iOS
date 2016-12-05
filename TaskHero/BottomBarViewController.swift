//
//  BottomBarViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/12/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

protocol ActionViewProtocol: class {
    func actionViewRequestedAction(bottomBarViewController: BottomBarViewController)
    func imageForActionView() -> UIImage
}

class BottomBarViewController: UIViewController {

    @IBOutlet weak var leftBarItemImageView: UIImageView!
    @IBOutlet weak var rightBarItemImageView: UIImageView!
    @IBOutlet weak var actionBarItemImageView: UIImageView!
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var actionView: ActionViewProtocol! {
        didSet {
            if let imageView = actionBarItemImageView {
                imageView.image = actionView?.imageForActionView()
            }
        }
    }
    
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
            
            contentViewController.view.frame = contentView.frame
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
        actionBarItemImageView.image = actionView?.imageForActionView()
        
        contentViewController = leftItemViewController
    }
    
    func show(animated: Bool = true) {
        if (barView.isHidden) {
            barView.isHidden = false
            contentViewBottomConstraint.constant = -self.barView.bounds.height
            
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
            }
            
            if (!animated) {
                bottomBarShownPosition()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.bottomBarShownPosition()
                }
            }
        }
    }
    
    private func bottomBarShownPosition() {
        self.contentViewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func hide(animated: Bool = true) {
        if (!barView.isHidden) {
            contentViewBottomConstraint.constant = 0
            
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
            }
            
            if (!animated) {
                bottomBarHiddenPosition()
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.bottomBarHiddenPosition()
                    },
                    completion: { complete in
                        self.barView.isHidden = true
                    }
                )
            }
        }
    }
    
    private func bottomBarHiddenPosition() {
        self.contentViewBottomConstraint.constant = -self.barView.bounds.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func onActionItemTapped(_ sender: UITapGestureRecognizer) {
        actionView?.actionViewRequestedAction(bottomBarViewController: self)
    }
    
    @IBAction func onBarItemTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == leftBarItemImageView {
            contentViewController = leftItemViewController
        } else if sender.view == rightBarItemImageView {
            contentViewController = rightItemViewController
        }
    }
    
    private func updateSelection() {
        leftBarItemImageView.tintColor = AppColors.appRed
        rightBarItemImageView.tintColor = AppColors.appRed
        
        if contentViewController == leftItemViewController {
            leftBarItemImageView.tintColor = AppColors.appBlue
        } else if contentViewController == rightItemViewController {
            rightBarItemImageView.tintColor = AppColors.appBlue
        }
    }
    
    func switchToLeftViewController() {
        if contentViewController != leftItemViewController {
            contentViewController = leftItemViewController
        }
    }
    
    func switchToRightViewController() {
        if contentViewController != rightItemViewController {
            contentViewController = rightItemViewController
        }
    }
}
