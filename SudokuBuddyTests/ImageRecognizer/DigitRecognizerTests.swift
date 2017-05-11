//
//  DigitRecognizerTests.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/8/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import XCTest
@testable import SudokuBuddy

class DigitRecognizerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTraining() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        for j in 1...9 {
            var trainingImages = [UIImage]()
            for i in 0...3 {
                guard let imagePath = Bundle.main.path(forResource: "img\(j)\(i)", ofType: "png"), let image = UIImage(contentsOfFile: imagePath) else {
                    XCTAssert(false)
                    return
                }
                trainingImages.append(image)
            }
            
            do {
                let digitIdentifier = try DigitRecognizer(trainingImages: trainingImages)
                
                XCTAssert(digitIdentifier.isTrained)
                
                for y in 0..<digitIdentifier.pixelMap.count {
                    var line = ""
                    for x in 0..<digitIdentifier.pixelMap[0].count {
                        line += digitIdentifier.pixelMap[y][x].printValue()
                    }
                    
                    print(line)
                }
            } catch {
                print(error)
                XCTAssert(false)
            }
        }
        
        
        XCTAssert(true)
        
        
    }
    
    func testSimilarity() {

        var compareImages = [Int: UIImage]()
        do {
            for i in 1...9 {
            let imgFat = UIImage(contentsOfFile: Bundle.main.path(forResource: "img\(i)3", ofType: "png")!)!
            let imgTrimmer = try ImageTrimmer(image: imgFat)
            XCTAssert(imgTrimmer.didFindDigitPoint())
            imgTrimmer.removeWhitespace()
            compareImages[i] = imgTrimmer.trimmedImage!
            }
        } catch {
            print(error)
        }
        
        for j in 1...9 {
            var trainingImages = [UIImage]()
            for i in 0...2 {
                guard let imagePath = Bundle.main.path(forResource: "img\(j)\(i)", ofType: "png"), let image = UIImage(contentsOfFile: imagePath) else {
                    XCTAssert(false)
                    return
                }
                trainingImages.append(image)
            }
            
            
            do {
                let digitIdentifier = try DigitRecognizer(trainingImages: trainingImages)
                
                XCTAssert(digitIdentifier.isTrained)
                
                for y in 0..<digitIdentifier.pixelMap.count {
                    var line = ""
                    for x in 0..<digitIdentifier.pixelMap[0].count {
                        line += digitIdentifier.pixelMap[y][x].printValue()
                    }
                    
                    print(line)
                    line = ""
                }
                
                var similarities = [(num: Int, sim: Float)]()
                
                for h in 1...9 {
                    let sim = digitIdentifier.similarity(image: compareImages[h]!)
                    similarities.append((num: h, sim: sim))
                }
                similarities.sort(by: {$0.sim > $1.sim})
                for item in similarities {
                    print("Similarity to \(item.num): \(item.sim)")
                }
                XCTAssert(similarities[0].num == j)
                print("\n\n")
                
            } catch {
                print(error)
                XCTAssert(false)
            }
        }
        
        
        XCTAssert(true)
    }
    
}
