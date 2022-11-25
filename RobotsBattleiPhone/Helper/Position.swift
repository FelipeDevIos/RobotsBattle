//
//  Position.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

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
        let x = self.x >= bundle.min && self.x <= bundle.max
        let y = self.y >= bundle.min && self.y <= bundle.max
        
        return x && y
    }
    
    func oppositePosition() -> Position {
        return Position(x: shuffle(value: self.x), y: shuffle(value: self.y))
    }
    
    func shuffle(value: Int) -> Int {
        if value == 1 {
            return 7
        } else {
            return 1
        }
    }
}

extension Position {
    enum Ranges {
        static let robot = [1, 7]
        static let prize = Array(1...7)
    }
    
    static func generatePosition(for range: [Int]) -> Position {
        let x = range.randomElement()
        let y = range.randomElement()
        
        if range == Ranges.prize {
            switch (x, y) {
            case (1, 1), (7, 7), (1, 7), (7, 1):
                return Position(x: 4, y: 4)
            default:
                return Position(x: x ?? 4, y: y ?? 4)
            }
        } else {
            return Position(x: x ?? 1, y: y ?? 1)
        }
    }
}

struct AvailableCell: Cell {
    var position: Position
    var location: PositionLabel
}

enum PositionLabel {
    case upper
    case left
    case right
    case lower
}
