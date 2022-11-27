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
}
