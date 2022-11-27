//
//  Position.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

/// Representation of each available cell
enum PositionLabel {
    case upper
    case left
    case right
    case lower
}

/// object coordinate
struct Position: Equatable {
    var x: Int
    var y: Int
}

extension Position {
    /// Upper cell
    /// - Returns: Position
    func upper() -> Position {
        Position(x: self.x, y: self.y - 1)
    }
    
    /// Left cell
    /// - Returns: Position
    func left() -> Position {
        Position(x: self.x - 1, y: self.y)
    }
    
    /// Right cell
    /// - Returns: Position
    func right() -> Position {
        Position(x: self.x + 1, y: self.y)
    }
    
    /// Lower cell
    /// - Returns: Position
    func lower() -> Position {
        Position(x: self.x, y: self.y + 1)
    }
    
    /// Evaluates if the cell is inside into the board limits
    /// - Returns: true if the cell is inside the board
    func available() -> Bool {
        let x = self.x >= boardLimits.min && self.x <= boardLimits.max
        let y = self.y >= boardLimits.min && self.y <= boardLimits.max
        
        return x && y
    }
    
    /// Returns the opposite position for a robot
    /// - Returns: New opposite position
    func oppositePosition() -> Position {
        return Position(x: shuffle(value: self.x), y: shuffle(value: self.y))
    }
    
    /// Shuffles the value of the original coordinate between board limits
    /// - Parameter value: point of coordinate
    /// - Returns: shuffled point
    func shuffle(value: Int) -> Int {
        value == 1 ? boardLimits.max : boardLimits.min
    }
    
    /// Determines if the prize has a valid empty position
    /// - Parameter position: current cell position
    /// - Returns: true/false in consequence
    func isAValidPrizePosition(on playedCells: [BattleCell]) -> Bool {
        return !playedCells.contains(where: {cell in
            cell.position == self
        })
    }
}

extension Position {
    /// Ranges for game elements
    enum Ranges {
        static let robot = [boardLimits.min, boardLimits.max]
        static let prize = Array(boardLimits.min...boardLimits.max)
    }
    
    /// Generate position for game elements
    /// - Parameter range: element range
    /// - Returns: position for element
    static func generatePosition(for range: [Int]) -> Position {
        let x = range.randomElement()
        let y = range.randomElement()
        
        if range == Ranges.prize {
            switch (x, y) {
            case (boardLimits.min, boardLimits.min), (boardLimits.max, boardLimits.max),
                (boardLimits.min, boardLimits.max), (boardLimits.max, boardLimits.min):
                return Position.generatePosition(for: Ranges.prize)
            default:
                let center = Int(ceil(Double(boardLimits.max) / 2.0))
                return Position(x: x ?? center , y: y ?? center)
            }
        } else {
            return Position(x: x ?? boardLimits.min, y: y ?? boardLimits.min)
        }
    }
}
