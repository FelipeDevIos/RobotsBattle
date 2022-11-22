//
//  Robot.swift
//  RobotsBattle
//
//  Created by X on 21/11/22.
//

import Foundation

struct Robot: BattleCell {
    var position: Position
    
    var totalWins: UInt
}

extension Robot {
    func nextCells() -> [Position] {
        var next = [Position]()
        
        if self.position.upper().available() {
            next.append(self.position.upper())
        }
        
        if self.position.left().available() {
            next.append(self.position.left())
        }
        
        if self.position.lower().available() {
            next.append(self.position.lower())
        }
        
        if self.position.right().available() {
            next.append(self.position.right())
        }
        
        return next
    }
}
