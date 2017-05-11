//
//  Row.swift
//  SudokuSolver
//
//  Created by Schuette, Peter on 12/24/16.
//  Copyright © 2016 Schuette, Peter. All rights reserved.
//

import Foundation

class Row:Group, Equatable {

    var index: Int
    
    var isVertical = false
    
    init(board: Board, index: Int, cells: [Cell]) {
        self.index = index
        
        super.init(board: board)

        self.cells = cells

        for cell in cells {
            cell.groups.append(self)
        }
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Row, rhs: Row) -> Bool {
        return lhs.index == rhs.index && lhs.isVertical == rhs.isVertical
    }
    
}
