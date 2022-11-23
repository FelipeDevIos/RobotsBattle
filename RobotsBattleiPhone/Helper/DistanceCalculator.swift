//
//  DistanceCalculator.swift
//  RobotsBattle
//
//  Created by Felipe Velandia  on 21/11/22.
//

import Foundation

class Distance {
    static func Calculator(origin: Position, target: Position) -> Double {
        let deltaX = Double(target.x - origin.x)
        let deltaY = Double(target.y - origin.y)
        let value = pow(deltaX, 2) + pow(deltaY, 2)

        return sqrt(value)
    }
}
