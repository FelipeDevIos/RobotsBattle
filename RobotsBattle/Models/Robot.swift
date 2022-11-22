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
    func nextCells() -> [AvailableCell] {
        var next = [AvailableCell]()
        
        if self.position.upper().available() {
            next.append(AvailableCell(
                position: self.position.upper(),
                location: .upper))
        }
        
        if self.position.left().available() {
            next.append(AvailableCell(
                position: self.position.left(),
                location: .left))
        }
        
        if self.position.lower().available() {
            next.append(AvailableCell(
                position: self.position.lower(),
                location: .lower))
        }
        
        if self.position.right().available() {
            next.append(AvailableCell(
                position: self.position.right(),
                location: .right))
        }
        
        return next
    }
}
