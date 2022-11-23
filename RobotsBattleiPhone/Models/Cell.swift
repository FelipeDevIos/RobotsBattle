//
//  BattleCell.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Foundation

let bundle = (min: 1, max: 7)

protocol Cell {
    var position: Position { get set }
    
    func toPosition(_ index: IndexPath) -> Position
}

extension Cell {
    func toPosition(_ index: IndexPath) -> Position {
        Position(x: index.section, y: index.item)
    }
}
