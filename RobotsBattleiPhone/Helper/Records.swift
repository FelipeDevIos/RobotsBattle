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

enum RecordsKeys: String {
    case gameResets
    case gameRounds
    case prizeRelocations
    case gameDraws
    case totalWins
    case totalSteps
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
        gameRounds = 0
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
    
    /// Records summary
    /// - Returns: Key value dictionary
    func summary() -> [String: Int] {
        var summary = [String: Int]()
        
        summary.updateValue(gameResets, forKey: RecordsKeys.gameResets.rawValue)
        summary.updateValue(gameRounds, forKey: RecordsKeys.gameRounds.rawValue)
        summary.updateValue(prizeRelocations, forKey: RecordsKeys.prizeRelocations.rawValue)
        summary.updateValue(gameDraws, forKey: RecordsKeys.gameDraws.rawValue)
        
        summary.updateValue(robot1.totalWins, forKey: "Robot1" + RecordsKeys.totalWins.rawValue)
        summary.updateValue(robot1.totalSteps, forKey: "Robot1" + RecordsKeys.totalSteps.rawValue)
        
        summary.updateValue(robot2.totalWins, forKey: "Robot2" + RecordsKeys.totalWins.rawValue)
        summary.updateValue(robot2.totalSteps, forKey: "Robot2" + RecordsKeys.totalSteps.rawValue)
        
        return summary
    }
}
