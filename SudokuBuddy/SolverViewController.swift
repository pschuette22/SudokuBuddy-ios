//
//  SolverViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/15/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit

class SolverViewController: UIViewController {
    
    var initialValues: [[Int]]!
    
    var solvedValues: [[Int]]?
    
    var puzzleView: PuzzleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width - 20.0
        let frame = CGRect(x: 10.0, y: 10.0, width: width, height: width)
        puzzleView = PuzzleView(frame: frame, puzzle: initialValues, isEditable: true)
        self.view.addSubview(puzzleView)
    }
    
    @IBAction func solvePuzzle(_ sender: Any) {
        solvePuzzle()
    }
    
    private func solvePuzzle() {
        
        let board = Board(values: initialValues)
        board.solve()
        
        // Find the puzzle view controller
        puzzleView.removeFromSuperview()
        
        solvedValues = board.values()
        let width = self.view.frame.width - 20.0
        let frame = CGRect(x: 10.0, y: 10.0, width: width, height: width)
        puzzleView = PuzzleView(frame: frame, puzzle: solvedValues!, isEditable: true)
        self.view.addSubview(puzzleView)
        
        // TODO: update puzzle view
    }
    
}
