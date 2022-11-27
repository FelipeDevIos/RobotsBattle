//
//  Robot.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

class Robot: Cell {
    var position: Position
    var path = [BattleCell]()
    
    init(position: Position, path: [BattleCell] = [BattleCell]()) {
        self.position = position
        self.path = path
    }
    
    /// Get total ammount of steps for robot. If necessary
    /// - Returns: total amount of steps per loop
    func getTotalSteps() -> Int {
        path.count
    }
}

extension Robot {
    /// Determines next available cells
    /// - Parameter playedCells: new cell shouldn't be a played one
    /// - Returns: available cells array
    func nextCells(without playedCells: [BattleCell]) -> [AvailableCell]? {
        var next = [AvailableCell]()
        
        var pathCell = playedCells
        
        if let index = playedCells.firstIndex(where: {$0.type == .prize}) {
            pathCell.remove(at: index)
        }
        
        var nextCell = BattleCell(position: position.upper())
        if position.upper().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: position.upper(),
                location: .upper))
        }
        
        nextCell = BattleCell(position: position.left())
        if position.left().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: position.left(),
                location: .left))
        }
        
        nextCell = BattleCell(position: position.lower())
        if position.lower().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: position.lower(),
                location: .lower))
        }
        
        nextCell = BattleCell(position: position.right())
        if position.right().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: position.right(),
                location: .right))
        }
        
        return next.isEmpty ? nil : next
    }
}

extension Robot {
    /// Detemines the next best cell to move
    /// - Parameter game: current game state
    /// - Returns: new best available position
    func findingBestNextCell(using game: Game) -> Position? {
        guard let nextCell = nextCells(without: game.playedCells) else { return nil }

        let target = game.prize
        var deltaDistance = Double(Int.max)
        var nextPosition = position
        
        nextCell.forEach {
            if Distance.Calculator(origin: $0.position, target: target.position) < deltaDistance {
                deltaDistance = Distance.Calculator(origin: $0.position, target: target.position)
                nextPosition = $0.position
            }
        }

        return nextPosition
    }
}
