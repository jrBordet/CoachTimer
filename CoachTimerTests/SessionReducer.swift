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
import SceneBuilder

class SessionReducer: XCTestCase {
	let env = SessionEnvironment(
		sync: { _ in
			.just(true)
		}
	)
	
	func testSessionUI() {
		let state = SessionState(
			id: "",
			user: User.sample,
			distance: 100,
			laps: [Lap.lap_0, .lap_1, Lap.lap_2],
			sessions: [],
			lapsCount: 3,
			peakSpeed: 10
		)
		
		let store = Store<SessionState, SessionAction>(
			initialValue: state,
			reducer: sessionReducer,
			environment: env
		)
		
		let vc = Scene<SessionViewController>().render()
		
		vc.store = store

		assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: false)
	}
	
	func testChartUI() {
		let state = SessionState(
			id: "",
			user: User.sample,
			distance: 100,
			laps: [Lap.lap_0, .lap_1, Lap.lap_2],
			sessions: [],
			lapsCount: 3,
			peakSpeed: 10
		)
		
		let store = Store<SessionState, SessionAction>(
			initialValue: state,
			reducer: sessionReducer,
			environment: env
		)
		
		let vc = Scene<SessionChartViewController>().render()
		
		vc.store = store
		
		assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: false)
	}
	
	func testStartAndCompleteSession() {
		assert(
			initialValue: SessionState(id: "", user: User.sample, distance: nil, laps: [], sessions: [], lapsCount: 0, peakSpeed: 0),
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, .name("test session name"), { state in
				state.id = "test session name"
			}), Step(.send, .distance(10), { state in
				state.distance = 10
			}),
			Step(.send, .lap(Lap.lap_0), { state in
				state.laps = [.lap_0]
				state.lapsCount = 1
				state.peakSpeed = 0.01
			}),
			Step(.send, .lap(Lap.lap_1), { state in
				state.laps = [
					.lap_0,
					.lap_1
				]
				
				state.lapsCount = 2
				state.peakSpeed = 0.01
			}),
			Step(.send, .saveCurrentSession, { state in
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
			}),
			Step(.receive, .syncResponse(true), { state in
				
			})
		)
	}
	
}
