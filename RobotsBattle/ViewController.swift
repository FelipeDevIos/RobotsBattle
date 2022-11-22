//
//  ViewController.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Cocoa

class ViewController: NSViewController {
    let game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()

        let prize = game.prize
        let robot1 = game.robot1
        let robot2 = game.robot2
        
        print(prize, robot1, robot2)

        findingBestPath(for: robot1, to: prize)
        findingBestPath(for: robot2, to: prize)
        
        print(findingBestNextCell(for: robot1, to: prize))
        print(findingBestNextCell(for: robot2, to: prize))
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
    
    func findingBestNextCell(for robot: Robot, to target: Prize) -> Robot {
        var deltaDistance = Double(Int.max)
        var nextRobot = robot
        
        robot.nextCells().forEach {
            if Distance.Calculator(origin: $0.position, target: target.position) < deltaDistance {
                deltaDistance = Distance.Calculator(origin: $0.position, target: target.position)
                nextRobot = Robot(position: $0.position, totalWins: 0)
            }
        }
        
        return nextRobot
    }
}

