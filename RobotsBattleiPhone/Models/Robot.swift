//
//  Robot.swift
//  RobotsBattle
//
//  Created by X on 21/11/22.
//

import Foundation

class Robot: Cell {
    var position: Position
    var path = [BattleCell]()
    
    func getTotalSteps() -> Int {
        path.count
    }
    
    init(position: Position, path: [BattleCell] = [BattleCell]()) {
        self.position = position
        self.path = path
    }
}

extension Robot {
    func nextCells(without playedCells: [BattleCell]) -> [AvailableCell]? {
        var next = [AvailableCell]()
        
        var pathCell = playedCells
        
        if let index = playedCells.firstIndex(where: {$0.type == .prize}) {
            pathCell.remove(at: index)
        }
        
        var nextCell = BattleCell(position: position.upper())
        if position.upper().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: self.position.upper(),
                location: .upper))
        }
        
        nextCell = BattleCell(position: position.left())
        if position.left().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: self.position.left(),
                location: .left))
        }
        
        nextCell = BattleCell(position: position.lower())
        if position.lower().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: self.position.lower(),
                location: .lower))
        }
        
        nextCell = BattleCell(position: position.right())
        if position.right().available() && !pathCell.contains(where: {$0.position == nextCell.position}) {
            next.append(AvailableCell(
                position: self.position.right(),
                location: .right))
        }
        
        return next.isEmpty ? nil : next
    }
}

extension Robot {
    func findingBestNextCell(using game: Game) -> Position? {
        guard let nextCell = nextCells(without: game.playedCells) else { return nil }

        let target = game.prize
        var deltaDistance = Double(Int.max)
        var nextPosition = self.position
        
        nextCell.forEach {
            if Distance.Calculator(origin: $0.position, target: target.position) < deltaDistance {
                deltaDistance = Distance.Calculator(origin: $0.position, target: target.position)
                nextPosition = $0.position
            }
        }

        return nextPosition
    }
}
