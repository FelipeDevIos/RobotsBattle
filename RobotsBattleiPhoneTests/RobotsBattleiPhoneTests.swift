//
//  RobotsBattleiPhoneTests.swift
//  RobotsBattleiPhoneTests
//
//  Created by Felipe Velandia  on 27/11/22.
//

import XCTest
@testable import RobotsBattleiPhone

final class RobotsBattleiPhoneTests: XCTestCase {
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
}
