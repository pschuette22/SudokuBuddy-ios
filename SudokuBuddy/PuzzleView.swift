//
//  PuzzleView.swift
//  SudokuBuddy
//
//  Created by Schuette, Peter on 5/13/17.
//  Copyright © 2017 Zeppa, LLC. All rights reserved.
//

import Foundation
import UIKit

class PuzzleView: UIView {
    
    private var values: [[Int]]!
    private var isEditable: Bool!
    
    private let cellDividerWidth = CGFloat(1)
    private let squareDividerWidth = CGFloat(2)
    
    private var sideLength: CGFloat!
    
    convenience init(frame: CGRect, puzzle values: [[Int]], isEditable: Bool) {
        self.init(frame: frame)
        self.values = values
        self.isEditable = isEditable

        // TODO: Fix this? Doesn't make sense to me
        sideLength = frame.size.width/9.0 - squareDividerWidth

        drawSubviews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // TODO: initialize a blank board
        // TODO: set default values
        // Only do this if I want to instantiate a PuzzleView from Storyboard
    }
    
    func drawSubviews() {
        
        for x in 0...8 {
            let xOffset = offset(at: x)
            for y in 0...8 {
                let yOffset = offset(at: y)
                let cellFrame = CGRect(x: xOffset, y: yOffset, width: sideLength, height: sideLength)
                let _cellView = cellView(frame: cellFrame, x: x, y: y)
                
                addSubview(_cellView)
            }
        }
        
    }
    
    private func offset(at index: Int) -> CGFloat {
        let _index = CGFloat(index)
        let squareDividers = CGFloat(index/3)
        return ((squareDividers + 1.0) * squareDividerWidth) + ((_index + 1.0) * cellDividerWidth) + _index * sideLength
    }
    
    private func cellView(frame: CGRect, x: Int, y: Int) -> UIView {
        let textView = UITextView(frame: frame)
        textView.textAlignment = .center
        textView.adjustsFontForContentSizeCategory = true
        textView.isEditable = isEditable
        let value = values[y][x]
        if value>0 {
            textView.text = String(describing: value)
        }
        return textView
    }
    
    private func staticCell(frame: CGRect, x: Int, y: Int) -> UIView {
        let textView = UILabel(frame: frame)
        textView.textAlignment = .center
        textView.adjustsFontForContentSizeCategory = true
        let value = values[y][x]
        if value>0 {
            textView.text = String(describing: value)
        }
        return textView
    }
    
    
    func board() -> Board {
        return Board(values: values)
    }
    
}
