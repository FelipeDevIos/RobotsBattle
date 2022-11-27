//
//  Game+Extensions.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 26/11/22.
//

import Foundation

/// Data object representing view buttons that change their state
enum AvailableButtons {
    case newLoop
    case relocatePrizeButton
    case pauseResume
}

/// Images to be shown on screen result spot
enum WinImages: String {
    case blueRobot = "R2_winner"
    case redRobot = "R1_winner"
    case draw = "draw"
}


/// Data object representing game elements
enum GameElements: String {
    case prize = "prize"
    case robot1 = "Robot 1"
    case robot2 = "Robot 2"
    case capture = "capture"
}

extension Game {
    /// Get new position for the prize
    func relocatePrize() {
        guard let prizeIndex = playedCells.firstIndex(where: {$0.type == .prize}) else { return }

        let newPrizePosition = Position.generatePosition(for: Position.Ranges.prize)
        
        guard playedCells.isAValidPrizePosition(newPrizePosition) else {
            relocatePrize()
            return
        }
        
        let prizeCell = BattleCell(position: newPrizePosition, type: .prize)
        playedCells[prizeIndex].position = newPrizePosition
        prize.position = prizeCell.position
        
        Records.shared.addPrizeRelocation()
    }
    
    /// Setting view when there is a final game state as draw or finished
    func configEndStateView() {
        updateViewDelegate?.setButton(enable: false, button: .relocatePrizeButton)
        updateViewDelegate?.setButton(enable: true, button: .newLoop)
        updateViewDelegate?.setButton(enable: false, button: .pauseResume)
    }
    
    /// Called everi time interval to evaluate robots and prize position and update game state
    @objc func plays() {
        /// Draw case
        if robot1 == nil && robot2 == nil {
            timeManageDelegate?.invalidateTime()

            updateViewDelegate?.showWinner(with: .draw)
            configEndStateView()
            
            Records.shared.addGameDraw()
            return
        /// Robot 1 on turn
        } else if onTurn == .robot1 {
            guard let robot1 = robot1, let nextCell = robot1.findingBestNextCell(using: self) else {
                robot1 = nil
                onTurn = .robot2
                return
            }
            
            robot1.position = nextCell
            let cell = BattleCell(position: robot1.position, type: .robot1)
            playedCells.append(cell)
            robot1.path.append(cell)
            self.robot1 = robot1
            onTurn = .robot2
            
            Records.shared.robot1.addingSteps()
        /// Robot 2 on turn
        } else if onTurn == .robot2 {
            guard let robot2 = robot2, let nextCell = robot2.findingBestNextCell(using: self) else {
                robot2 = nil
                onTurn = .robot1
                return
            }
            
            robot2.position = nextCell
            let cell = BattleCell(position: robot2.position, type: .robot2)
            playedCells.append(cell)
            robot2.path.append(cell)
            self.robot2 = robot2
            onTurn = .robot1
            
            Records.shared.robot2.addingSteps()
        }
        
        let gameOver = gameOver()
        
        /// Evaluating if there is a winner on current game state
        if gameOver.result {
            if let prizeIndex = playedCells.firstIndex(where: {$0.type == .prize}) {
                playedCells[prizeIndex].type = .capture
                updateViewDelegate?.setButton(enable: false, button: .relocatePrizeButton)
            }
            
            timeManageDelegate?.invalidateTime()
            
            switch gameOver.winner {
            case .robot1 :
                updateViewDelegate?.showWinner(with: .redRobot)
            case .robot2 :
                updateViewDelegate?.showWinner(with: .blueRobot)
            default: break
            }
            
            updateViewDelegate?.updateScores()
            
            configEndStateView()
        }
        
        updateViewDelegate?.updateBoard()
    }
    
    /// Evaluates if there is a winner
    /// - Returns: Tupple with result for winner and the winner
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

