//
//  UsersSessionsReducerTests.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import XCTest
@testable import CoachTimer
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxComposableArchitectureTests
import SnapshotTesting

class UsersSessionsReducerTests: XCTestCase {
	let env_filled = UsersViewEnvironment(
		userEnv: UsersEnvironment(
			fetch: {
				.just([
					.sample,
					.sample_1
				])
			},
			persistUsers: { users in
				.just(true)
			},
			loadUsers: {
				.just([])
			}
		),
		sessionEnv: SessionEnvironment(
			sync: { _ in
				.just(true)
			}
		)
	)
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testSingleUserSelection() {
		let date = Date()
		
		let state = UsersSessionsViewState(
			list: [],
			isLoading: false,
			alert: nil,
			currentPage: 1,
			currentUser: nil,
			currentSession: Session(id: date, user: .sample, distance: 100, laps: []),
			sessions: []
		)
		
		assert(
			initialValue: UsersSessionsViewState.empty,
			reducer: usersSessionsiewReducer,
			environment: env_filled,
			steps: Step(.send, UsersSessionsViewAction.user(UsersAction.fetch), { state in
				state.isLoading = true
				state.currentSession = Session(id: nil, user: nil, distance: nil, laps: [])
			}),
			Step(.receive, UsersSessionsViewAction.user(UsersAction.fetchResponse([.sample, .sample_1])), { state in
				state.list = [
					.sample,
					.sample_1
				]
				
				state.currentPage = 2
				
				state.isLoading = false				
			}),
			Step(.receive, UsersSessionsViewAction.user(UsersAction.persistUsersResponse(true)), { state in
				
			})
		)
	}
	
	func testCompleteSession() {
		let date = Date()
		
		assert(
			initialValue: UsersSessionsViewState.empty,
			reducer: usersSessionsiewReducer,
			environment: env_filled,
			steps: Step(.send, .user(.fetch), { state in
				state.isLoading = true
				state.currentSession = Session(id: nil, user: nil, distance: nil, laps: [])
			}),
			Step(.receive, .user(.fetchResponse([.sample, .sample_1])), { state in
				state.list = [
					.sample,
					.sample_1
				]
				
				state.currentPage = 2
				
				state.isLoading = false
			}),
			Step(.receive, .user(.persistUsersResponse(true)), { state in
				
			}),
			Step(.send, UsersSessionsViewAction.user(.selectUser(.sample)), { state in
				state.currentUser = .sample
				state.currentSession = Session(id: nil, user: .sample, distance: nil, laps: [])
			}),
			Step(.send, UsersSessionsViewAction.session(.id(date)), { state in
				state.currentSession = Session(id: date, user: .sample, distance: 0, laps: [])
			}),
			Step(.send, UsersSessionsViewAction.session(.distance(100)), { state in
				state.currentSession = Session(id: date, user: .sample, distance: 100, laps: [])
			}),
			Step(.send, UsersSessionsViewAction.session(.laps([.lap_0, .lap_1])), { state in
				state.currentSession = Session(id: date, user: .sample, distance: 100, laps: [.lap_0, .lap_1])
			}),
			Step(.send, UsersSessionsViewAction.session(.saveCurrentSession(date)), { state in
				state.sessions = [
					Session(id: date, user: .sample, distance: 100, laps: [.lap_0, .lap_1])
				]
			}), Step(.receive, UsersSessionsViewAction.session(SessionAction.syncResponse(true)), { state in
				
			})
		)
	}
	
	func testTimeFormat() {
		let result = stringFromTimeInterval(1)
		
		XCTAssertEqual("00:00.1", result)
		
		let result2 = stringFromTimeInterval(4435 / 1000)
		
		XCTAssertEqual("00:00.4", result2)
	}
	
	func testSpeedAccuracy() {
		let result = stringFromTimeInterval(6375)
		
		XCTAssertEqual("10:37.5", result)
		
		let speed: Double = 10 / (6375 / 1000)
		
		XCTAssertEqual(1.56, speed, accuracy: 0.2)
	}
}
