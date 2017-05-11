//
//  ImageTrimmerTests.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/7/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import XCTest
@testable import SudokuBuddy

class ImageTrimmerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPrintImages() {
        
        for j in 1...9 {
            for i in 0..<4 {
                guard let imagePath = Bundle.main.path(forResource: "img\(j)\(i)", ofType: "png") else {
                    XCTAssert(false)
                    return
                }
                print(imagePath)
                
                guard let image = UIImage(contentsOfFile: imagePath) else {
                    XCTAssert(false)
                    return
                }
                do {
                    let trimmer = try ImageTrimmer(image: image)
                    XCTAssert(trimmer.didFindDigitPoint())
                    trimmer.removeWhitespace()
                    
                    guard let trimmed = trimmer.trimmedImage else {
                        XCTAssert(false)
                        return
                    }
                    trimmed.debugPrint()
                    
                } catch let err {
                    print(err)
                    XCTAssert(false)
                }
            }
        }
        
        
        XCTAssert(true)
    }
    
    func testFindDigitPoint() {
        guard let image = UIImage(named: "sample2") else {
            XCTAssert(false)
            return
        }
        
        do {
            let trimmer = try ImageTrimmer(image: image)
            
            XCTAssert(trimmer.didFindDigitPoint())
            let specialCharacters = [(x: trimmer.px!, y: trimmer.py!, char: "O")]
            printPixels(trimmer.pixels, replace: specialCharacters)
            
            
        } catch let err {
            print(err)
            XCTAssert(false)
        }
        XCTAssert(true)
        
    }
    
    func testRemoveWhiteSpace() {
        guard let image = UIImage(named: "sample2") else {
            XCTAssert(false)
            return
        }
        
        do {
            let trimmer = try ImageTrimmer(image: image)
            
            XCTAssert(trimmer.didFindDigitPoint())
            trimmer.removeWhitespace()
            
            guard let trimmedPixels = trimmer.trimmedImage?.getPixelMap() else {
                XCTAssert(false)
                return
            }
            
            print("\n\n")
            
            printPixels(trimmer.pixels, replace: [])
            
            print("\n\n Trimmed to: \n\n")
            
            printPixels(trimmedPixels, replace: [])
            
        } catch let err {
            print(err)
            XCTAssert(false)
        }
    }
    
    
    func printPixels(_ pixels: [[Pixel]], replace specialCharacters: [(x: Int, y: Int, char: String)]) {
        
        for y in 0..<pixels.count {
            var line = ""
            let specialInYColumn = specialCharacters.filter({$0.y == y})
            xloop: for x in 0..<pixels[0].count {
                for special in specialInYColumn {
                    if special.x == x {
                        line += special.char
                        continue xloop
                    }
                }
                
                line += pixels[y][x].printValue()
            }
            print(line)
            line = ""
        }
        
    }
    
}
