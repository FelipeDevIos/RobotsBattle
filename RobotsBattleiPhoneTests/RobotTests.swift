//
//  RobotTests.swift
//  RobotsBattleiPhoneTests
//
//  Created by Anonymous on 27/11/22.
//

import XCTest
@testable import RobotsBattleiPhone

final class RobotTests: XCTestCase {
    func test_robotIslocatedOnBoardCorners() {
        let boardCorners = getDefaultPositions()
        
        let robotPosition = Position.generatePosition(for: Position.Ranges.robot)
        
        XCTAssertTrue(boardCorners.contains(robotPosition))
    }
    
    func test_prizeIslocatedOnNonBoardCorners() {
        let boardCorners = getDefaultPositions()
        
        let prizePosition = Position.generatePosition(for: Position.Ranges.prize)
        
        XCTAssertFalse(boardCorners.contains(prizePosition))
    }
    
    func test_robotPositionOppositeToFirstRobotPosition() {
        let robot1Position = Position.generatePosition(for: Position.Ranges.robot)
        let robot2Position = robot1Position.oppositePosition()
        
        let oppositeX = robot1Position.shuffle(value: robot1Position.x)
        let oppositeY = robot1Position.shuffle(value: robot1Position.y)
        
        XCTAssertEqual(robot2Position.x, oppositeX)
        XCTAssertEqual(robot2Position.y, oppositeY)
    }
    
    // MARK: helper
    
    func getDefaultPositions() -> [Position] {
        return [Position(x: boardLimits.min, y: boardLimits.min),
                Position(x: boardLimits.min, y: boardLimits.max),
                Position(x: boardLimits.max, y: boardLimits.min),
                Position(x: boardLimits.max, y: boardLimits.max)]
    }
}
