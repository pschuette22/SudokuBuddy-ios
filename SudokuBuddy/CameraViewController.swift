//
//  ScannerViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 4/19/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit


class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
 
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraFlashMode = .auto
        imagePicker.allowsEditing = true
        
        // TODO: show some text and a button if user cancels giving them the option to take a picture again
        
        
        launchCamera()
    }

    
    func launchCamera() {
        present(imagePicker, animated: true,completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let navigationController = self.navigationController else { return }

        // Launch image editing
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoEditingViewController = storyboard.instantiateViewController(withIdentifier: "PhotoEditingViewController") as! PhotoEditingViewController
        photoEditingViewController.initialImage = image
        
        navigationController.pushViewController(photoEditingViewController, animated: true)
        
    }
    
}
