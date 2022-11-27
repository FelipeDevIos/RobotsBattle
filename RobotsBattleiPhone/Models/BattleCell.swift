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

extension Array where Element == BattleCell {
    /// Determines if the cell has a valid empty position
    /// - Parameter position: current cell position
    /// - Returns: true/false in consequence
    func isAValidCell(_ position: Position) -> Bool {
        return !self.contains(where: {cell in
            cell.position == position
        })
    }
}
