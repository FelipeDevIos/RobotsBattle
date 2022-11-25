//
//  Records.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 23/11/22.
//

import Foundation

class Records {
    static let shared = Records()
    
    private init() {}
    
    var robot1Wins: Int = 0
    var robot2Wins: Int = 0
    
    func restartGame() {
        robot1Wins = 0
        robot2Wins = 0
    }
}
