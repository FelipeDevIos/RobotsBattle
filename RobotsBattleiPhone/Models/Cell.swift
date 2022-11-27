//
//  BattleCell.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

let boardLimits = (min: 1, max: 7)

/// Protocol for cells
protocol Cell {
    var position: Position { get set }
    
    /// Changes indexPath to position type
    /// - Parameter index: indexPath
    /// - Returns: new position
    func toPosition(_ index: IndexPath) -> Position
    /// Return index from position
    /// - Returns: indexPath
    func toIndexPath() -> IndexPath
}

extension Cell {
    func toPosition(_ index: IndexPath) -> Position {
        Position(x: index.section, y: index.item)
    }
    
    func toIndexPath() -> IndexPath {
        IndexPath(item: self.position.y, section: self.position.x)
    }
}
