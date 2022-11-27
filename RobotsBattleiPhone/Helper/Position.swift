//
//  Position.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

enum PositionLabel {
    case upper
    case left
    case right
    case lower
}

struct Position: Equatable {
    var x: Int
    var y: Int
}

extension Position {
    func upper() -> Position {
        Position(x: self.x, y: self.y - 1)
    }
    
    func left() -> Position {
        Position(x: self.x - 1, y: self.y)
    }
    
    func right() -> Position {
        Position(x: self.x + 1, y: self.y)
    }
    
    func lower() -> Position {
        Position(x: self.x, y: self.y + 1)
    }
    
    func available() -> Bool {
        let x = self.x >= boardLimits.min && self.x <= boardLimits.max
        let y = self.y >= boardLimits.min && self.y <= boardLimits.max
        
        return x && y
    }
    
    func oppositePosition() -> Position {
        return Position(x: shuffle(value: self.x), y: shuffle(value: self.y))
    }
    
    func shuffle(value: Int) -> Int {
        if value == 1 {
            return boardLimits.max
        } else {
            return boardLimits.min
        }
    }
}

extension Position {
    enum Ranges {
        static let robot = [boardLimits.min, boardLimits.max]
        static let prize = Array(boardLimits.min...boardLimits.max)
    }
    
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
