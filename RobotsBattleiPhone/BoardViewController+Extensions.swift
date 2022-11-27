//
//  BoardViewController+Extensions.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 26/11/22.
//

import Foundation
import UIKit

extension BoardViewController {
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
    
    func showScores() {
        redRobotWinsLabel.text = "\(Records.shared.robot1.totalWins) \(Constants.wins)"
        blueRobotWinsLabel.text = "\(Records.shared.robot2.totalWins) \(Constants.wins)"
    }
    
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
    
    func settingControl(enable: Bool, _ button: UIButton) {
        button.isUserInteractionEnabled = enable
        button.isEnabled = enable
    }
    
    @objc func plays() {
        game.plays()
    }
}
