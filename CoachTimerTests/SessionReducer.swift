//
//  SessionReducer.swift
//  CoachTimerTests
//
//  Created by Jean Raphael Bordet on 18/06/21.
//

import XCTest
@testable import CoachTimer
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxComposableArchitectureTests
import SnapshotTesting

class SessionReducer: XCTestCase {
	let env = SessionEnvironment()
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testStartSession() {
		assert(
			initialValue: SessionState(user: User.sample, distance: nil, laps: []),
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, SessionAction.distance(10), { state in
				state.distance = 10
			}),
			Step(.send, SessionAction.lap(Lap.lap_0), { state in
				state.laps = [.lap_0]
			}),
			Step(.send, SessionAction.lap(Lap.lap_1), { state in
				state.laps = [
					.lap_0,
					.lap_1
				]
			})
		)
	}
	
}
