//
//  Pizel.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/7/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation


public struct Pixel {
    
    var r,g,b,a: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    
    /// Determine if this pixel is "Dark"
    ///
    /// - Returns: True if this is a dark pixel
    public func isDarkPoint() -> Bool {
        return r < 100 && g < 100 && b < 100
    }
    
    
    /// Get a printable value for this pixel
    ///
    /// - Returns: 
    public func printValue() -> String {
        
        if r < 50 && g < 50 && b < 50 {
            return "D"
        } else if r < 100 && g < 100 && b < 100 {
            return "A"
        } else if r < 150 && g < 150 && b < 150 {
            return "7"
        } else if r < 200 && g < 200 && b < 200 {
            return "4"
        }
        
        return " "
    }
    
    public func similarity(to pixel: Pixel) -> Float {
        let sum1 = Float(r) + Float(g) + Float(b)
        let sum2 = Float(pixel.r) + Float(pixel.g) + Float(pixel.b)
        
        let diff = abs(sum1-sum2)
        let total = Float(255.0*3)
        return 1.0 - (diff / total)
    }
    
}
