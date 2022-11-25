//
//  Game.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 22/11/22.
//

import Foundation

enum GameElements: String {
    case prize = "prize"
    case robot1 = "Robot 1"
    case robot2 = "Robot 2"
    case capture = "capture"
}

extension GameElements {
    
}

class Game {
    var prize: Prize
    var robot1: Robot
    var robot2: Robot
    var playedCells: [BattleCell]
    
    init() {
        prize = Prize(position: Position.generatePosition(for: Position.Ranges.prize))
        
        let robotPosition = Position.generatePosition(for: Position.Ranges.robot)
        robot1 = Robot(position: robotPosition)
        robot2 = Robot(position: robotPosition.oppositePosition())
        
        playedCells = [BattleCell]()
        playedCells.append(BattleCell(position: prize.position, type: .prize))
        playedCells.append(BattleCell(position: robot1.position, type: .robot1))
        playedCells.append(BattleCell(position: robot2.position, type: .robot2))
    }
}
