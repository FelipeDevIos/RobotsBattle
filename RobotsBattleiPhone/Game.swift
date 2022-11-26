//
//  Game.swift
//  RobotsBattle
//
//  Created by Anonymous on 22/11/22.
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
    var robot1: Robot?
    var robot2: Robot?
    var playedCells = [BattleCell]()
    var onTurn: GameElements = .robot1
    
    init() {
        prize = Prize(position: Position.generatePosition(for: Position.Ranges.prize))
        
        let robotPosition = Position.generatePosition(for: Position.Ranges.robot)
        robot1 = Robot(position: robotPosition)
        robot2 = Robot(position: robotPosition.oppositePosition())
        
        guard let r1 = robot1, let r2 = robot2 else { return }
        
        playedCells.append(BattleCell(position: prize.position, type: .prize))
        playedCells.append(BattleCell(position: r1.position, type: .robot1))
        playedCells.append(BattleCell(position: r2.position, type: .robot2))
    }
}

extension Game {
    func gameOver() -> (result: Bool, winner: GameElements) {
        let robot1 = robot1?.position == prize.position
        let robot2 = robot2?.position == prize.position
        let winner = robot1 ? GameElements.robot1 : robot2 ? GameElements.robot2 : GameElements.prize
        
        switch winner {
        case .robot1: Records.shared.robot1.addingWin()
        case .robot2: Records.shared.robot2.addingWin()
        default: break
        }
        
        return (robot1 || robot2, winner)
    }
}
