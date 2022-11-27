//
//  Game.swift
//  RobotsBattle
//
//  Created by Anonymous on 22/11/22.
//

import Foundation

/// In charge of UI updates
protocol UpdateViewStateProtocol {
    /// Updates UI board
    func updateBoard()
    /// Upadates winner scores
    func updateScores()
    /// Updates winner images
    /// - Parameter image: WinImages type to be shown
    func showWinner(with image: WinImages)
    /// Sets new statwe of desired button
    /// - Parameters:
    ///   - enable: enables/disables button
    ///   - button: desired button
    func setButton(enable: Bool, button: AvailableButtons)
}

/// Timmer bridge
protocol TimeManageProtocol {
    /// Invalidates timmer for turns
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
