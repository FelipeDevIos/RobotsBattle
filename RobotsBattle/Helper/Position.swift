//
//  Position.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Foundation

struct Position {
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
}
