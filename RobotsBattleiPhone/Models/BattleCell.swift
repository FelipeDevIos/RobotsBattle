//
//  BattleCell.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 22/11/22.
//

import Foundation

struct BattleCell: Cell, Equatable {
    var position: Position
    var type: GameElements?
}

extension Array where Element == BattleCell {
    func isAValidCell(_ position: Position) -> Bool {
        return !self.contains(where: {cell in
            cell.position == position
        })
    }
}
