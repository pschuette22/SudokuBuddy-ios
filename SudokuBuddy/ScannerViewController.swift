//
//  ScannerViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 4/19/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit


class ScannerViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
 
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: true,completion: nil)
        
        
    }
    
    
}
