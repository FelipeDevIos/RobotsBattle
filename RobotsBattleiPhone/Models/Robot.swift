//
//  Robot.swift
//  RobotsBattle
//
//  Created by X on 21/11/22.
//

import Foundation

struct Robot: Cell {
    var position: Position
    var totalWins: UInt
}

extension Robot {
    func nextCells() -> [AvailableCell] {
        var next = [AvailableCell]()
        
        if self.position.upper().available() {
            next.append(AvailableCell(
                position: self.position.upper(),
                location: .upper))
        }
        
        if self.position.left().available() {
            next.append(AvailableCell(
                position: self.position.left(),
                location: .left))
        }
        
        if self.position.lower().available() {
            next.append(AvailableCell(
                position: self.position.lower(),
                location: .lower))
        }
        
        if self.position.right().available() {
            next.append(AvailableCell(
                position: self.position.right(),
                location: .right))
        }
        
        return next
    }
}

extension Robot {
    func findingBestNextCell(to target: Prize) -> Robot {
        var deltaDistance = Double(Int.max)
        var nextRobot = self
        
        nextCells().forEach {
            if Distance.Calculator(origin: $0.position, target: target.position) < deltaDistance {
                deltaDistance = Distance.Calculator(origin: $0.position, target: target.position)
                nextRobot = Robot(position: $0.position, totalWins: 0)
            }
        }

        return nextRobot
    }
    
    func findingBestPath(for robot: Robot, to target: Prize) {
        guard Distance.Calculator(origin: robot.position, target: target.position) != 0 else {
            print("Final", robot.position)
            return
        }

        var deltaDistance = Double(Int.max)
        var nextRobot = robot

        print(nextRobot.position)

        robot.nextCells().forEach {
            if Distance.Calculator(origin: $0.position, target: target.position) < deltaDistance {
                deltaDistance = Distance.Calculator(origin: $0.position, target: target.position)
                nextRobot = Robot(position: $0.position, totalWins: 0)
            }
        }
        
        findingBestPath(for: nextRobot, to: target)
    }
}
