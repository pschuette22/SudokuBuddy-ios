//
//  PuzzelRecognizer.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/10/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit


/// Recognizer object used for
class PuzzleRecognizer {
    
    var digitRecognizers: [Int: DigitRecognizer]
    
    // initialize the default puzzle recognizer
    public convenience init() {
        
        var digitRecognizers = [Int: DigitRecognizer]()
        
        for i in 1...9 {
            var trainingImages = [UIImage]()
            for j in 0...3 {
                guard let imagePath = Bundle.main.path(forResource: "img\(i)\(j)", ofType: "png"), let image = UIImage(contentsOfFile: imagePath) else {
                    continue
                }
                trainingImages.append(image)
            }
            do {
                digitRecognizers[i] = try DigitRecognizer(trainingImages: trainingImages)
            } catch {
                // eat this error too
            }
        }
        self.init(digitRecognizers: digitRecognizers)
    }
    
    
    public init(digitRecognizers: [Int: DigitRecognizer]) {
        self.digitRecognizers = digitRecognizers
    }
    
    
    public func evaluate(puzzle puzzleImage: UIImage) throws -> [[Int]] {
        
        var puzzle = [[Int]]()
        // Break the puzzle into 9x9 grid
        let cellWidth = puzzleImage.size.width/9
        let cellHeight = puzzleImage.size.height/9
        
        for y in 0..<9 {
            let originy = CGFloat(y)*cellHeight
            var row = [Int]()
            for x in 0..<9 {
                let originx = CGFloat(x)*cellWidth
                
                let cellFrame = CGRect(x: originx, y: originy, width: cellWidth, height: cellHeight)
                guard let puzzleClone = puzzleImage.clone() else {
                    row.append(0)
                    continue
                }
                let cellImg = puzzleClone.crop(rect: cellFrame)
                
                let trimmer = try ImageTrimmer(image: cellImg)
                if trimmer.didFindDigitPoint() {
                    trimmer.removeWhitespace()
                    guard let trimmedImg = trimmer.trimmedImage else {
                        row.append(0)
                        continue
                    }
                    row.append(evaluate(digit: trimmedImg))
                } else {
                    // This is a 0 point
                    row.append(0)
                }
                
            }
            puzzle.append(row)
        }
        
        
        return puzzle
    }
    
    
    public func evaluate(digit digitImg: UIImage) -> Int {
        
        var highSim = Float(0.0)
        var number = 0
        for i in 1...9 {
            let digitSim = digitRecognizers[i]!.similarity(image: digitImg)
            if digitSim>highSim {
                highSim = digitSim
                number = i
            }
        }
        
        if highSim < 0.5 {
            // Less than 50% similarity..
            return 0
        }
        
        
        return number
    }
    
    
    
}
