//
//  BattleCell.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Foundation

struct BattleCell {
    let position: Position
    var owner: Robot?
    
    func toPosition(_ index: IndexPath) -> Position {
        Position(x: index.section, y: index.item)
    }
}
