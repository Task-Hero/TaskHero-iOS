//
//  StepDetailViewController.swift
//  TaskHero
//
//  Created by Akifumi Shinagawa on 11/13/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class StepDetailViewController: UIViewController {

    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var stepDescription: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var attachedImageView: UIImageView!
    
    var taskInstance: TaskInstance!
    var step: Step!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppColors.loadNavigationBarColors(navigationController: navigationController!)
        stepName.text = step.name
        stepDescription.text = step.details
        setUserImages()
        setStateImageView()
        loadSavedImage()
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUserImages() {
        let imageViewArray = [imageView1, imageView2, imageView3, imageView4, imageView5]
        for (index, user) in (step.assignees?.enumerated())! {
            if index > 4 {
                break
            }
            imageViewArray[index]?.setImageWith(user.profileImageUrl)
            imageViewArray[index]?.clipsToBounds = true
            imageViewArray[index]?.layer.cornerRadius = (imageViewArray[index]?.bounds.width)! / 2
        }
    }
    
    func setStateImageView() {
        if step.state == StepState.completed {
            statusImageView.image = UIImage(named: "CheckMark")
        } else {
            statusImageView.image = UIImage(named: "Attention")
        }
    }
    
    func loadSavedImage() {
        ParseClient.sharedInstance.loadStepImage(taskInstance: taskInstance, step: step, success: { (image) -> () in
            NSLog("loading image")
            self.attachedImageView.image = image
        }, failure: { (error) -> () in
            NSLog("error loading image, or no saved images. e=\(error)")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.attachedImageView.image = image
        
        ParseClient.sharedInstance.saveStepImage(taskInstance: taskInstance, step: step, image: image!, success: { () -> () in
            NSLog("image saved.")
        }, failure: { (error) -> () in
            NSLog("error saving image. e=\(error)")
        })
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension StepDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func onCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

