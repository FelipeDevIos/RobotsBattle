//
//  Records.swift
//  RobotsBattleiPhone
//
//  Created by Anonymous on 23/11/22.
//

import Foundation

/// Data Object to gather analytics
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
    
    /// Restarts related analitycs
    func restartGame() {
        setUp()
        gameResets = 0
        gameDraws = 0
        prizeRelocations = 0
    }
    
    /// Sets up the analytics objects
    func setUp() {
        robot1 = RobotForMetrics()
        robot2 = RobotForMetrics()
    }
    
    // MARK: Game rounds
    func addGameRounds() {
        gameRounds += 1
    }
    
    func getGameRounds() -> Int {
        gameRounds
    }
    
    // MARK: Game resets
    func addGameResets() {
        gameResets += 1
    }
    
    func getGameResets() -> Int {
        gameResets
    }
    
    // MARK: Game prize relocations
    func addPrizeRelocation() {
        prizeRelocations += 1
    }
    
    func getPrizeRelocations() -> Int {
        prizeRelocations
    }
    
    // MARK: Game draws
    func addGameDraw() {
        gameDraws += 1
    }
    
    func getGameDraws() -> Int {
        gameDraws
    }
}
