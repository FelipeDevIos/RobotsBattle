//
//  BattleCell.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 22/11/22.
//

import Foundation

struct AvailableCell: Cell {
    var position: Position
    var location: PositionLabel
}

struct BattleCell: Cell, Equatable {
    var position: Position
    var type: GameElements?
}
