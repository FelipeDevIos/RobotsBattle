//
//  Game.swift
//  RobotsBattle
//
//  Created by Anonymous on 22/11/22.
//

import Foundation

protocol UpdateViewStateProtocol {
    func updateBoard()
    func updateScores()
    func showWinner(with image: WinImages)
    func setButton(enable: Bool, button: AvailableButtons)
}

protocol GameStates {
    func drawGame()
}

protocol TimeManageProtocol {
    func invalidateTime()
}

class Game {
    enum Constants {
        static let timeInterval: TimeInterval = 1
    }
    
    var prize: Prize
    var robot1: Robot?
    var robot2: Robot?
    var playedCells = [BattleCell]()
    var onTurn: GameElements = .robot1
    
    var updateViewDelegate: UpdateViewStateProtocol?
    var gameStateDelegate: GameStates?
    var timeManageDelegate: TimeManageProtocol?
    
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
