//
//  PhotoEditingViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/13/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit
import AKImageCropperView

class PhotoEditingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    // The image that is initi
    var initialImage: UIImage!

    @IBOutlet weak var cropperView: AKImageCropperView!
    
    
    @IBAction func doSolve(_ sender: Any) {
        // TODO: display an alert if the view doesn't crop
        guard let croppedImage = cropperView.croppedImage else { return }
     
        
        if let puzzleValues = extractPuzzle(from: croppedImage) {
            
            guard let navigationController = self.navigationController else { return }
            
            // Launch image editing
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let solverViewController = storyboard.instantiateViewController(withIdentifier: "SolverViewController") as! SolverViewController
            solverViewController.initialValues = puzzleValues
            
            navigationController.pushViewController(solverViewController, animated: true)
            
            
            
        } else {
            print("failed to retrieve puzzle values")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cropperView.image = initialImage
        
    }
    
    private func extractPuzzle(from image: UIImage) -> [[Int]]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let puzzleRecognizer = appDelegate.puzzleRecognizer
     
        do {
            let recognizedValues = try puzzleRecognizer.evaluate(puzzle: image)
            return recognizedValues
        } catch {
            print(error)
        }
        return nil
    }
    
}
