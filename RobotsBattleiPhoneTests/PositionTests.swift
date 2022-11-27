//
//  Anonymous.swift
// Anonymous
//
//  Created by Anonymous on 27/11/22.
//

import XCTest
@testable import RobotsBattleiPhone

final class PositionTests: XCTestCase {
    func test_cellToIndex() {
        let position = Position(x: 3, y: 5)
        let cell = BattleCell(position: position)
        
        let indexPathTest = IndexPath(item: 5, section: 3)
        
        XCTAssertEqual(indexPathTest, cell.toIndexPath())
    }
    
    func test_IndexToCell() {
        let indexPathTest = IndexPath(item: 5, section: 3)
        
        let position = Position(x: 3, y: 5)
        let cell = BattleCell(position: position)
        
        XCTAssertEqual(position, cell.toPosition(indexPathTest))
    }
    
    func test_prizeHasValidPosition() {
        let prizePosition = Position(x: 4, y: 4)
        var playedCells = [BattleCell]()
        playedCells.append(BattleCell(position: Position(x: 1, y: 1)))
        playedCells.append(BattleCell(position: Position(x: 5, y: 5)))
        playedCells.append(BattleCell(position: Position(x: 7, y: 7)))
        
        XCTAssertTrue(prizePosition.isAValidPrizePosition(on: playedCells))
    }
    
    func test_prizeHasNoValidPosition() {
        let prizePosition = Position(x: 5, y: 5)
        var playedCells = [BattleCell]()
        playedCells.append(BattleCell(position: Position(x: 1, y: 1)))
        playedCells.append(BattleCell(position: Position(x: 5, y: 5)))
        playedCells.append(BattleCell(position: Position(x: 7, y: 7)))
        
        XCTAssertFalse(prizePosition.isAValidPrizePosition(on: playedCells))
    }
    
    func test_prizePositionIsOnBoard() {
        let prizeRange = Position.Ranges.prize
        let position = Position.generatePosition(for: prizeRange)
        
        XCTAssertNotNil(position)
    }
    
    func test_robotPositionIsOnBoard() {
        let prizeRange = Position.Ranges.robot
        let position = Position.generatePosition(for: prizeRange)
        
        XCTAssertNotNil(position)
    }
    
    func test_prizePositionsIsAlwaysOnBoardNoMatterBoardSize() {
        let newBoardLimits = (min: 1, max: 3)
        
        let prizeRange = Array(newBoardLimits.min...newBoardLimits.max)
        let position = Position.generatePosition(for: prizeRange)
        
        XCTAssertNotNil(position)
    }
    
    func test_robotPositionsIsAlwaysOnBoardNoMatterBoardSize() {
        let newBoardLimits = (min: 1, max: 3)
        
        let prizeRange = [newBoardLimits.min, newBoardLimits.max]
        let position = Position.generatePosition(for: prizeRange)
        
        XCTAssertNotNil(position)
    }
    
    func test_nonBorderPositionHasFourAvailableCellToMove() {
        let position = Position(x: 5, y: 5)
        let robot = Robot(position: position)
        
        let availableCells = robot.nextCells(without: [])
        
        XCTAssertEqual(availableCells?.count, 4)
    }
    
    func test_cornerPositionHasTwoAvailableCellToMove() {
        let position = Position(x: 1, y: 1)
        let robot = Robot(position: position)
        
        let availableCells = robot.nextCells(without: [])
        
        XCTAssertEqual(availableCells?.count, 2)
    }
    
    func test_borderPositionHasThreeAvailableCellToMove() {
        let position = Position(x: 5, y: 1)
        let robot = Robot(position: position)
        
        let availableCells = robot.nextCells(without: [])
        
        XCTAssertEqual(availableCells?.count, 3)
    }
    
    func test_havingTwoPositionsGettingDirectDistance() {
        let position1 = Position(x: 1, y: 1)
        let position2 = Position(x: 1, y: 7)
        
        let expectedDistance = 6.0
        
        XCTAssertEqual(expectedDistance, Distance.Calculator(origin: position1, target: position2))
    }
}
