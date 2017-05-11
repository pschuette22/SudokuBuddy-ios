//
//  NumberRecognizer.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 4/30/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

enum DRError: Error {
    case initError(message: String)
}

class DigitRecognizer {
    
    public var isTrained = false
    public var pixelMap: [[Pixel]]!
    public var width: Int = 0
    public var height: Int = 0
    
    
    init(trainingImages: [UIImage]) throws {
        
        if trainingImages.isEmpty {
            throw DRError.initError(message: "Tried to initialize a recognizer with no training data")
        }
        
        // set the height and width of identifer canvas as the max height and width of training data images
        var _trainingImages = [UIImage]()
        for image in trainingImages {
            do {
                let trimmer = try ImageTrimmer(image: image)
                if !trimmer.didFindDigitPoint() {
                    continue
                }
                trimmer.removeWhitespace()
                
                guard let trimmedImage = trimmer.trimmedImage else {
                    continue
                }
                // Set the total width and height of trained image
                // This is assuming plenty of white space
                width = max(width, Int(trimmedImage.size.width))
                height = max(height, Int(trimmedImage.size.height))
                _trainingImages.append(trimmedImage)
            } catch let err {
                print(err)
            }
        }
        
        
        train(with: _trainingImages)
    }
    
    
    
    /// Train the digit recognizer with an array of images
    ///
    /// - Parameter images: array of images of the same digit for training
    private func train(with images: [UIImage]) {
        
        if images.isEmpty {
            // No need to train with empty data
            return
        }
        
        pixelMap = [[Pixel]]()
        
        // Initialize the digit map
        for _ in 0..<height {
            var row = [Pixel]()
            for _ in 0..<width {
                let pixel = Pixel(r: 0, g: 0, b: 0, a: 255)
                row.append(pixel)
            }
            pixelMap.append(row)
        }
        
        // Average out all the images
        // Assume they have the same height and width for now
        let imageCount = Double(images.count)
        for image in images {
            
            // Because frame is maxed out at this point,
            // we can assume the map height and width will be
            // equal or greater to this calculated image height and width
            
            guard let trainingPixelMap = image.getPixelMap() else { continue }
            
            let heightRatio = Double(trainingPixelMap.count) / Double(pixelMap.count)
            let widthRatio = Double(trainingPixelMap[0].count) / Double(pixelMap[0].count)
            
            
            for y in 0..<pixelMap.count {
                let ty = Int((Double(y)*heightRatio).rounded(.down))
                for x in 0..<pixelMap[0].count {
                    let tx = Int((Double(x)*widthRatio).rounded(.down))
                    // Get the currently mapped pixel
                    let pixel = pixelMap[y][x]
                    
                    let trainingPixel = trainingPixelMap[ty][tx]
                    // Calculate the color component values including the average
                    let r = pixel.r + UInt8(Double(trainingPixel.r) / imageCount)
                    let g = pixel.g + UInt8(Double(trainingPixel.g) / imageCount)
                    let b = pixel.b + UInt8(Double(trainingPixel.b) / imageCount)
                    // replace the mapped pixel with new values
                    pixelMap[y][x] = Pixel(r: r, g: g, b: b, a: 255)
                }
            }
        }
        
        isTrained = true
        
    }
    
    
    
    /// Calculate the similarity of this image to another
    ///
    /// - Parameter image: <#image description#>
    /// - Returns: <#return value description#>
    public func similarity(image: UIImage) -> Float {
        // Assumes images have been trimmed by the time they get here.
        
        guard let comparePixelMap = image.getPixelMap() else { return 0.0 }
        
        let heightRatio = Double(comparePixelMap.count) / Double(pixelMap.count)
        let widthRatio = Double(comparePixelMap[0].count) / Double(pixelMap[0].count)
        
        var totalSim = Float(0.0)
        for y in 0..<pixelMap.count {
            let cy = Int((Double(y)*heightRatio).rounded(.down))
            for x in 0..<pixelMap[y].count {
                let cx = Int((Double(x)*widthRatio).rounded(.down))
                let pixelSim = pixelMap[y][x].similarity(to: comparePixelMap[cy][cx])
                totalSim += pixelSim
            }
        }
        
        totalSim /= Float(pixelMap.count*pixelMap[0].count)
        
        return totalSim
    }
    
    
    
}
