//
//  Game.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 22/11/22.
//

import Foundation

enum GameElements {
    case prize
    case robot1
    case robot2
}

class Game {
    var prize: Prize
    var robot1: Robot
    var robot2: Robot
    
    init() {
        prize = Prize(position: Position.generatePosition(for: Position.Ranges.prize))
        
        let robotPosition = Position.generatePosition(for: Position.Ranges.robot)
        robot1 = Robot(position: robotPosition, totalWins: 0)
        robot2 = Robot(position: robotPosition.oppositePosition(), totalWins: 0)
    }
}
