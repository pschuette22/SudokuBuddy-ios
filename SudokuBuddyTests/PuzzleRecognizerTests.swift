//
//  PuzzleRecognizerTests.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/10/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import XCTest
@testable import SudokuBuddy

class PuzzleRecognizerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecognizePuzzle() {
        
        let puzzleRecognizer = PuzzleRecognizer()
        
        guard let imagePath = Bundle.main.path(forResource: "puzzle1", ofType: "png"), let image = UIImage(contentsOfFile: imagePath) else {
            XCTAssert(false)
            return
        }
        do {
            let puzzle = try puzzleRecognizer.evaluate(puzzle: image)
            
            for y in 0..<puzzle.count {
                if y%3 == 0 {
                    print("\n")
                }
                var line = ""
                for x in 0..<puzzle[0].count {
                    if x%3 == 0 {
                        line += "  "
                    }
                    line += "\(puzzle[y][x])"
                }
                print(line)
            }
            print("\n")
            
            
            // Solve the puzzle
            let board = Board(values: puzzle)
            board.solve()
            
            board.print()
            
            
        } catch {
            XCTAssert(false)
            return
        }
        XCTAssert(true)
        
    }
    
}
