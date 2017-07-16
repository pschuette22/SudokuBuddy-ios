//
//  UploadViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/15/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    
    let imagePicker = UIImagePickerController()
    
    var nav: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        self.nav = self.navigationController
        
        // TODO: Give the user the option
        launchCamera()
    }
    
    
    func launchCamera() {
        present(imagePicker, animated: true,completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        if let values = extractPuzzle(from: image) {
            navigateToSolver(with: values)
        } else {
            // TODO: inflate a dialog
        }
        
    }
    
    func extractPuzzle(from image: UIImage) -> [[Int]]? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let puzzleRecognizer = delegate.puzzleRecognizer
        do {
            let values = try puzzleRecognizer.evaluate(puzzle: image)
            return values
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    func navigateToSolver(with puzzle: [[Int]]) {
        guard let navigationController = self.nav else { return }
        
        // Launch image editing
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let solverViewController = storyboard.instantiateViewController(withIdentifier: "SolverViewController") as! SolverViewController
        solverViewController.initialValues = puzzle
        navigationController.pushViewController(solverViewController, animated: true)
    }
    
    
}

