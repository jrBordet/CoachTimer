//
//  LeaderboardTests.swift
//  CoachTimerTests
//
//  Created by Jean Raphael Bordet on 19/06/21.
//

import XCTest
@testable import CoachTimer
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxComposableArchitectureTests
import SnapshotTesting

class LeaderboardTests: XCTestCase {
	
	let env = LeaderboardEnvironment()
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testLeaderboardLapsStort() throws {		
		assert(
			initialValue: LeaderboardState(
				sessions: [
					Session.one,
					Session.two
				],
				sort: .speed
			),
			reducer: leaderboardReducer,
			environment: env,
			steps: Step(.send, LeaderboardAction.sort(.laps), { state in
				state.sort = .laps
				state.sessions = [
					.two,
					.one
				]
			})
		)
	}
	
}
