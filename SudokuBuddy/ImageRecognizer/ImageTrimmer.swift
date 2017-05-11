//
//  ImageTrimmer.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/7/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit


public class ImageTrimmer {
    
    // Image that will be trimmed
    var image: UIImage
    var pixels: [[Pixel]]!
    var trimmedImage: UIImage?
    
    init(image: UIImage) throws {
        self.image = image
        guard let pixels = image.getPixelMap() else {
            // TODO: make this a more descriptive error
            throw NSError()
        }
        self.pixels = pixels
    }
    
    var px,py: Int?
    
    /// Find a point on the image
    public func didFindDigitPoint() -> Bool {

        let startx = pixels[0].count/2
        let starty = pixels.count/2
        
        if pixels[starty][startx].isDarkPoint() {
            py = starty
            px = startx
            return true
        }
        
        var minx = startx
        var maxx = startx
        var miny = starty
        var maxy = starty
        
        let lowerXBound = startx - startx/2
        let upperXBound = startx + startx/2
        let lowerYBound = starty - starty/2
        let upperYBound = starty + starty/2
        
        // Loop while our bounds are within the search radius
        while minx >= lowerXBound && maxx <= upperXBound && miny >= lowerYBound && maxy <= upperYBound {
            // Expand the boundries
            minx = minx-1
            maxx = maxx+1
            miny = miny-1
            maxy = maxy+1
            
            // Check pixels on the top and bottom
            for x in minx..<maxx {
                if pixels[miny][x].isDarkPoint() {
                    px = x
                    py = miny
                    return true
                } else if pixels[maxy][x].isDarkPoint() {
                    px = x
                    py = maxy
                    return true
                }
            }
            // Check pixels on the left and right
            for y in miny..<maxy {
                if pixels[y][minx].isDarkPoint() {
                    px = minx
                    py = y
                    return true
                } else if pixels[y][maxx].isDarkPoint() {
                    px = maxx
                    py = y
                    return true
                }
            }
            
        }
        
        return false
    }
    
    
    public func removeWhitespace() {

        print("Found digit point: \(px),\(py)")
        
        // Start at the given px,py
        // Work way out until there is only space at the bounds. 
        // After there is only space,
        var minx = px!-1
        var miny = py!-1
        var maxx = px!+1
        var maxy = py!+1
        
        mainLoop: while minx>=0, miny>=0, maxx<pixels[0].count, maxy < pixels.count {
            // Expand the x bounds
            for y in miny...maxy {
                if pixels[y][minx].isDarkPoint(), minx>0 {
                    minx = minx-1
                    continue mainLoop
                } else if pixels[y][maxx].isDarkPoint(), maxx < pixels.count-1 {
                    maxx =  maxx+1
                    continue mainLoop
                }
            }
            
            // Expand the y bounds
            for x in minx...maxx {
                if pixels[miny][x].isDarkPoint(), miny>0 {
                    miny = miny-1
                    continue mainLoop
                } else if pixels[maxy][x].isDarkPoint(), maxy < pixels[0].count-1 {
                    maxy = maxy + 1
                    continue mainLoop
                }
            }
            // If we get here, we have trimmed the image
            break
        }
        
        // determine the proper points and crop the image accordingly
        let origin = CGPoint(x: minx, y: miny)
        let size = CGSize(width: maxx-minx, height: maxy-miny)
        let croppedFrame = CGRect(origin: origin, size: size)
        let clone = image.clone()
        trimmedImage = clone?.crop(rect: croppedFrame)
        
    }
    
}
