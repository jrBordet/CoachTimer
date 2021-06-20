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
	
	func testStartAndCompleteSession() {
		assert(
			initialValue: SessionState(id: "", user: User.sample, distance: nil, laps: [], sessions: [], lapsCount: 0, peakSpeed: 0),
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, SessionAction.name("test session name"), { state in
				state.id = "test session name"
			}), Step(.send, SessionAction.distance(10), { state in
				state.distance = 10
			}),
			Step(.send, SessionAction.lap(Lap.lap_0), { state in
				state.laps = [.lap_0]
				state.lapsCount = 1
				state.peakSpeed = 0.01
			}),
			Step(.send, SessionAction.lap(Lap.lap_1), { state in
				state.laps = [
					.lap_0,
					.lap_1
				]
				
				state.lapsCount = 2
				state.peakSpeed = 0.01
			}),
			Step(.send, SessionAction.saveCurrentSession, { state in
				state.sessions = [
					Session(
						id: "test session name",
						user: User.sample,
						distance: 10,
						laps: [
							.lap_0,
							.lap_1
						]
					)
				]
				
				state.peakSpeed = 0.01
			})
		)
	}
	
}
