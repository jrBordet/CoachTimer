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
			id: nil,
			user: User.sample,
			distance: 100,
			laps: [Lap.lap_0, .lap_1, Lap.lap_2],
			sessions: [],
			lapsCount: 3,
			peakSpeed: 10,
			sort: .speed,
			exportSuccess: nil
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
			id: nil,
			user: User.sample,
			distance: 100,
			laps: [Lap.lap_0, .lap_1, Lap.lap_2],
			sessions: [],
			lapsCount: 3,
			peakSpeed: 10,
			sort: .speed,
			exportSuccess: nil
		)
		
		let store = Store<SessionState, SessionAction>(
			initialValue: state,
			reducer: sessionReducer,
			environment: env
		)
		
		let expectation = self.expectation(description: "Scaling")
		
		let vc = Scene<SessionChartViewController>().render()

		vc.store = store
		assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: false)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
			expectation.fulfill()
		})
		
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testSaveSessionEmptyLaps() {
		let session: SessionState = .empty
		
		assert(
			initialValue: session,
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, .saveCurrentSession(Date()), { state in
				state.sessions = []
			}), Step(.send, .laps([]), { state in
				state.sessions = []
			})
		)
	}
	
	func testStartAndCompleteCurrentSession() {
		let date = Date()
		
		let state = SessionState(
			id: nil,
			user: .sample,
			distance: nil,
			laps: [],
			sessions: [],
			lapsCount: 0,
			peakSpeed: 0,
			sort: .speed,
			exportSuccess: nil
		)
		
		assert(
			initialValue: state,
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, .id(date), { state in
				state.id = date
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
			Step(.send, .saveCurrentSession(date), { state in
				state.sessions = [
					Session(
						id: date,
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
	
	func testStartAndCompleteSession() {
		let date = Date()
				
		let state = SessionState(
			id: nil,
			user: .sample,
			distance: nil,
			laps: [],
			sessions: [
				.one
			],
			lapsCount: 0,
			peakSpeed: 0,
			sort: .speed,
			exportSuccess: nil
		)
		
		assert(
			initialValue: state,
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, .id(date), { state in
				state.id = date
			}), Step(.send, .distance(10), { state in
				state.distance = 10
			}),
			Step(.send, .laps([.lap_0, .lap_1, .lap_2]), { state in
				state.laps = [.lap_0, .lap_1, .lap_2]
				state.lapsCount = 3
				state.peakSpeed = 0.0125
			}),
			Step(.send, .saveCurrentSession(date), { state in
				state.sessions = [
					.one, 
					Session(
						id: date,
						user: User.sample,
						distance: 10,
						laps: [
							.lap_0,
							.lap_1,
							.lap_2
						]
					)
				]
				
				state.peakSpeed = 0.0125
			}),
			Step(.receive, .syncResponse(true), { state in
				
			})
		)
	}
	
	func testStartAndCompleteEnduranceSession() {
		let date = Date()
				
		let state = SessionState(
			id: nil,
			user: .sample,
			distance: nil,
			laps: [],
			sessions: [
				.one
			],
			lapsCount: 0,
			peakSpeed: 0,
			sort: .laps,
			exportSuccess: nil
		)
		
		assert(
			initialValue: state,
			reducer: sessionReducer,
			environment: env,
			steps: Step(.send, .id(date), { state in
				state.id = date
			}), Step(.send, .distance(10), { state in
				state.distance = 10
			}),
			Step(.send, .laps([.lap_0, .lap_1, .lap_2]), { state in
				state.laps = [.lap_0, .lap_1, .lap_2]
				state.lapsCount = 3
				state.peakSpeed = 0.0125
			}),
			Step(.send, .saveCurrentSession(date), { state in
				state.sessions = [
					Session(
						id: date,
						user: User.sample,
						distance: 10,
						laps: [
							.lap_0,
							.lap_1,
							.lap_2
						]
					),
					.one
				]
				
				state.peakSpeed = 0.0125
			}),
			Step(.receive, .syncResponse(true), { state in
				
			})
		)
	}
}
