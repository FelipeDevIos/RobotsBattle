//
//  GameTests.swift
//  RobotsBattleiPhoneTests
//
//  Created by Felipe Velandia  on 27/11/22.
//

import XCTest
@testable import RobotsBattleiPhone

final class GameTests: XCTestCase {

    func test_afterPrizeRelocationNewPositionIsDifferentFromOriginalPosition() {
        let game = Game()
        let prizeInitiaPosition = game.prize.position
        
        game.relocatePrize()
        
        XCTAssertNotEqual(prizeInitiaPosition, game.prize.position)
    }
    
    func test_ifRobotAndPrizeHaveTheSamePositionTheGameIsOver() {
        let game = Game()
        let robotPositionOverPrizePosition = game.prize.position
        
        game.robot1?.position = robotPositionOverPrizePosition
        let gameIsOver = game.gameOver().result
        
        XCTAssertTrue(gameIsOver)
    }
    
    func test_gameLoopGeneratesNewPositionForFirstRobotPosition() {
        let game = Game()
        let robot1FirstPosition = game.robot1?.position
        
        game.plays()
        
        XCTAssertNotEqual(robot1FirstPosition, game.robot1?.position)
    }

    func test_gameTwoLoopsGeneratesNewPositionForBothRobotsPosition() {
        let game = Game()
        
        let robot1FirstPosition = game.robot1?.position
        let robot2FirstPosition = game.robot2?.position
        
        game.plays()
        game.plays()
        
        XCTAssertNotEqual(robot1FirstPosition, game.robot1?.position)
        XCTAssertNotEqual(robot2FirstPosition, game.robot2?.position)
    }
    
    func test_gameLoopGeneratesDoesNotChangeSecondRobotPosition() {
        let game = Game()
        let robot2FirstPosition = game.robot2?.position
        
        game.plays()
        
        XCTAssertEqual(robot2FirstPosition, game.robot2?.position)
    }
    
    func test_ifRobotsCantMoveTheGameIsDraw() {
        let game = Game()
        
        game.robot1?.position = Position(x: 1, y: 1)
        game.robot2?.position = Position(x: 1, y: 2)
        
        game.playedCells = [BattleCell(position: Position(x: 2, y: 1)),
                            BattleCell(position: Position(x: 2, y: 2)),
                            BattleCell(position: Position(x: 2, y: 3)),
                            BattleCell(position: Position(x: 1, y: 3))]
        
        game.plays()
        game.plays()
        game.plays()
        game.plays()
        
        XCTAssertNil(game.robot1)
        XCTAssertNil(game.robot2)
    }
}
