//
//  DistanceCalculator.swift
//  RobotsBattle
//
//  Created by Anonymous on 21/11/22.
//

import Foundation

class Distance {
    /// Distance calculator between robots and target based on Pythagoras theorem using coordinates for each
    /// element under evaluation
    /// - Parameters:
    ///   - origin: initial object
    ///   - target: final object
    /// - Returns: The distance between the objects
    static func Calculator(origin: Position, target: Position) -> Double {
        let deltaX = Double(target.x - origin.x)
        let deltaY = Double(target.y - origin.y)
        let value = pow(deltaX, 2) + pow(deltaY, 2)

        return sqrt(value)
    }
}
