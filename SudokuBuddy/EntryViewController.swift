//
//  EntryViewController.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/12/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: UIViewController {
    
    var puzzleView: PuzzleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width - 20.0
        let frame = CGRect(x: 10.0, y: 10.0, width: width, height: width)
        puzzleView = PuzzleView(frame: frame, puzzle: buildEmptyPuzzle(), isEditable: true)
        self.view.addSubview(puzzleView)
    }
    
    private func buildTestPuzzle() -> [[Int]] {
        var testPuzzle = [[Int]]()
        for i in 0...8 {
            var row = [Int]()
            for _ in 0...8 {
                row.append(i)
            }
            testPuzzle.append(row)
        }
        return testPuzzle
    }
    
    private func buildEmptyPuzzle() -> [[Int]] {
        var emptyPuzzle = [[Int]]()
        for _ in 0...8 {
            var row = [Int]()
            for _ in 0...8 {
                row.append(0)
            }
            emptyPuzzle.append(row)
        }
        return emptyPuzzle
    }
    
    
}
