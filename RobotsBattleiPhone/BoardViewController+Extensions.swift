//
//  BoardViewController+Extensions.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 26/11/22.
//

import Foundation
import UIKit

extension BoardViewController {
    /// Creating game instancea and setting ui
    func setUpLogic() {
        game = Game()
        game.timeManageDelegate = self
        game.updateViewDelegate =  self
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
        winnerImage.image = #imageLiteral(resourceName:  "Playing")
        
        settingControl(enable: false, newLoopButton)
        settingControl(enable: true, relocatePrizeButton)
        settingControl(enable: true, pauseGameButton)
        
        collectionView.reloadData()
    }
    
    /// Changes the scores label for both robots
    func showScores() {
        redRobotWinsLabel.text = "\(Records.shared.robot1.totalWins) \(Constants.wins)"
        blueRobotWinsLabel.text = "\(Records.shared.robot2.totalWins) \(Constants.wins)"
    }
    
    /// Pauses and resumes timer to allow user to pause/resume game
    func pauseResumeTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: Constants.timeInterval, target: self, selector: #selector(plays), userInfo: nil, repeats: true)
            pauseGameButton.setTitle(Constants.pause, for: .normal)
        } else {
            timer?.invalidate()
            timer = nil
            pauseGameButton.setTitle(Constants.resume, for: .normal)
        }
    }
    
    /// Changing ui for desired button
    /// - Parameters:
    ///   - enable: enable or not a button
    ///   - button: desired button
    func settingControl(enable: Bool, _ button: UIButton) {
        button.isUserInteractionEnabled = enable
        button.isEnabled = enable
    }
    
    /// Starts each game interaction
    @objc func plays() {
        game.plays()
    }
}
