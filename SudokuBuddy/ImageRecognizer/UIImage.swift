//
//  UIImage.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/10/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// Loosely based on:
    /// http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
    ///
    /// - Returns: Image as an array of arrays of pixel structures
    func getPixelMap() -> [[Pixel]]? {
        guard let cgi = self.cgImage else { return nil }
        guard let pixelData = cgi.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var result = [[Pixel]]()
        for y in 0..<Int(size.height) {
            var row = [Pixel]()
            for x in 0..<Int(size.width) {
                let pixelInfo = (cgi.width * y + x) * 4
                let r = data[pixelInfo]
                let g = data[pixelInfo+1]
                let b = data[pixelInfo+2]
                let a = data[pixelInfo+3]
                let pixel = Pixel(r: r, g: g, b: b, a: a)
                row.append(pixel)
            }
            result.append(row)
        }
        
        return result
    }

    public func debugPrint() {
        guard let pixelMap = getPixelMap() else {
            print("Unable to get pixel map!")
            return
        }
        

        for y in 0..<Int(size.height) {
            var line = ""
            for x in 0..<Int(size.width) {
                line += pixelMap[y][x].printValue()
            }
            print(line)
        }
    }
    
    /// Borrowed from http://stackoverflow.com/questions/39310729/problems-with-cropping-a-uiimage-in-swift
    ///
    /// - Parameter rect: <#rect description#>
    /// - Returns: <#return value description#>
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    
    /// Create a clone of this image
    ///
    /// - Returns: Exact clone of this image
    func clone() -> UIImage? {
        guard let cgi = self.cgImage else { return nil }
        guard let newCgim = cgi.copy() else { return nil }
        return UIImage(cgImage: newCgim, scale: self.scale, orientation: self.imageOrientation)
    }
}

