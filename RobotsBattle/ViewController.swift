//
//  ViewController.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let prize = Prize(position: Position(x: 2, y: 4))
        let robot1 = Robot(position: Position(x: 1, y: 7), totalWins: 0)
        let robot2 = Robot(position: Position(x: 7, y: 1), totalWins: 0)
        
        print(Distance.Calculator(origin: robot1.position, target: prize.position))
        print(Distance.Calculator(origin: robot2.position, target: prize.position))
        
        robot1.nextCells().forEach {
            print($0)
        }
    }
}

