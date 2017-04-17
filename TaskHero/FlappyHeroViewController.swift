//
//  FlappyHeroViewController.swift
//  TaskHero
//
//  Created by Agarwal, Sahil on 4/16/17.
//  Copyright © 2017 Task Hero. All rights reserved.
//

import UIKit

class FlappyHeroViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var pipe1ImageView: UIImageView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var push: UIPushBehavior!
    var collision: UICollisionBehavior!
    var heroItemBehavior: UIDynamicItemBehavior!
    var pipeItemBehavior: UIDynamicItemBehavior!
    
    var forwardVelocity:CGFloat = 0
    var pipeVelocity:CGFloat = -175
    var pipeHeight = 160
    var gravityVelocity:Double = 1.3
    var level:Int = 1
    var score = 0
    var pipeTimer:Double = 1.6
    var alive:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator()
        setupInitialBackgroundAndImages()
        setupInitialGravityBehavior()
        setupInitialPushBehavior()
        setupInitialCollisionBehavior()
        collision.collisionDelegate = self
        setupInitialHeroItemBehavior()
        setupInitialPipeItemBehavior()
        setupBoundaries()
        tapGesture(target: view)
        Timer.scheduledTimer(timeInterval: pipeTimer, target: self, selector: #selector(self.drawPipes), userInfo: nil, repeats: true)
    }
    
    func setupInitialBackgroundAndImages() {
        backgroundImageView.image = UIImage(named: "bg")
        heroImageView.image = UIImage(named: "Emblem")
        heroImageView.transform = heroImageView.transform.rotated(by: CGFloat.pi * CGFloat(0.15))
        pipe1ImageView.image = UIImage(named: "pipeTop")
    }
    
    func setupInitialGravityBehavior() {
        gravity = UIGravityBehavior(items: [heroImageView])
        gravity.gravityDirection = CGVector(dx: 0.0, dy: gravityVelocity)
        animator.addBehavior(gravity)
    }
    
    func setupInitialPushBehavior() {
        push = UIPushBehavior(items: [heroImageView], mode: UIPushBehaviorMode.instantaneous)
        animator.addBehavior(push)
    }
    
    func setupInitialCollisionBehavior() {
        collision = UICollisionBehavior(items: [heroImageView, pipe1ImageView])
        animator.addBehavior(collision)
    }
    
    func setupInitialHeroItemBehavior() {
        heroItemBehavior = UIDynamicItemBehavior(items: [heroImageView])
        heroItemBehavior.addLinearVelocity(CGPoint(x: forwardVelocity, y: 0), for: heroImageView)
        animator.addBehavior(heroItemBehavior)
    }
    
    func setupInitialPipeItemBehavior() {
        pipeItemBehavior = UIDynamicItemBehavior(items: [pipe1ImageView])
        pipeItemBehavior.addLinearVelocity(CGPoint(x: pipeVelocity, y: 0), for: pipe1ImageView)
        animator.addBehavior(pipeItemBehavior)
    }
    
    func setupBoundaries() {
        collision.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint(x: 0, y: view.frame.maxY + 50), to: CGPoint(x: view.frame.maxX, y: view.frame.maxY + 50))
        
        collision.addBoundary(withIdentifier: "leftSide" as NSCopying, from: CGPoint(x: -100, y: view.frame.minY), to: CGPoint(x: -100, y: view.frame.maxY))
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        heroItemBehavior.addLinearVelocity(CGPoint(x: -heroItemBehavior.linearVelocity(for: heroImageView).x, y: 0), for: heroImageView)
        if (heroItemBehavior.linearVelocity(for: heroImageView).y < 250) {
            push.pushDirection = CGVector(dx: 0, dy: -1.5)
        } else {
            push.pushDirection = CGVector(dx: 0, dy: -1.25 * gravity.magnitude)
        }
        heroItemBehavior.addLinearVelocity(CGPoint(x: forwardVelocity, y: -heroItemBehavior.linearVelocity(for: heroImageView).y), for: heroImageView)
        push.active = true
    }
    
    func tapGesture(target: UIView) {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTapGesture(sender:)))
        target.addGestureRecognizer(tapGesture)
    }
    
    func drawPipes() {
        if (alive) {
            makeTopAndBottomPipe()
            score += 1
            if (score % 5 == 0) {
                difficultSelector()
            }
        }
    }
    
    func difficultSelector() {
        level += 1
        pipeVelocity -= 25
    }
    
    func makePipe(bottomPipe: Bool) {
        var image = UIImage(named: "pipeTop")
        let x = Int(view.frame.maxX)
        var y = Int(view.frame.minY)
        pipeHeight = Int(view.frame.height / 4.85)
        let height = Int(arc4random_uniform(185) + UInt32(pipeHeight))
        
        if (bottomPipe) {
            image = UIImage(named: "pipeBottom")
            y = Int(view.frame.maxY) - height
        }
        
        let width = Int(Double((image?.cgImage?.width)!) * Double(arc4random_uniform(3) + 4) / 3)
        let cgRect = CGRect(x: x, y: y, width: width, height: height)
        let imageView = UIImageView(frame: cgRect)
        imageView.image = image
        collision.addItem(imageView)
        pipeItemBehavior.addItem(imageView)
        pipeItemBehavior.addLinearVelocity(CGPoint(x: pipeVelocity, y: 0), for: imageView)
        backgroundImageView.addSubview(imageView)
    }
    
    func makeTopPipe() {
        makePipe(bottomPipe: false)
    }
    
    func makeBottomPipe() {
        makePipe(bottomPipe: true)
    }
    
    func makeTopAndBottomPipe() {
        makeTopPipe()
        makeBottomPipe()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        // You have to convert the identifier to a string
        let boundary = identifier as! String
        // The view that collided with the boundary has to be converted to a view
        let view = item as! UIView
        
        if boundary == "leftSide" {
            UIView.animate(withDuration: 0, animations: {() -> Void in}, completion: { (true) -> Void in
                self.collision.removeItem(view)
                view.removeFromSuperview()
                
            })
        } else if (boundary == "bottom") {
            endGame()
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        endGame()
    }
    
    func endGame() {
        alive = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
