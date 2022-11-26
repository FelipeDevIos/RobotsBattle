//
//  Records.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 23/11/22.
//

import Foundation

struct RobotForMetrics {
    var totalWins = 0
    var totalSteps = 0
    
    mutating func addingWin() {
        totalWins += 1
    }
    
    mutating func addingSteps() {
        totalSteps += 1
    }
}


class Records {
    static let shared = Records()
    
    var robot1 = RobotForMetrics()
    var robot2 = RobotForMetrics()
    
    private var gameResets: Int = 0
    private var gameRounds: Int = 0
    private var prizeRelocations: Int = 0
    private var gameDraws: Int = 0
    
    private init() {}
    
    func restartGame() {
        setUp()
        gameResets = 0
        gameDraws = 0
    }
    
    func setUp() {
        robot1 = RobotForMetrics()
        robot2 = RobotForMetrics()
    }
    
    func addGameRounds() {
        gameRounds += 1
    }
    
    func getGameRounds() -> Int {
        gameRounds
    }
    
    func addGameResets() {
        gameResets += 1
    }
    
    func getGameResets() -> Int {
        gameResets
    }
    
    func addPrizeRelocation() {
        prizeRelocations += 1
    }
    
    func getPrizeRelocations() -> Int {
        prizeRelocations
    }
    
    func addGameDraw() {
        gameDraws += 1
    }
    
    func getGameDraws() -> Int {
        gameDraws
    }
}
