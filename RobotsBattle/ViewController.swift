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
        
        print(prize.position, "\n R1:", robot1.position, "\n R2:",robot2.position)

        robot1.findingBestPath(for: robot1, to: prize)
        robot2.findingBestPath(for: robot2, to: prize)
        
        print(robot1.findingBestNextCell(to: prize))
        print(robot2.findingBestNextCell(to: prize))
    }
}

