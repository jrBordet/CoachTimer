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
		)
	)
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testSingleUserSelection() {
		assert(
			initialValue: UsersSessionsViewState.empty,
			reducer: usersSessionsiewReducer,
			environment: env_filled,
			steps: Step(.send, UsersSessionsViewAction.user(UsersAction.fetch), { state in
				state.isLoading = true
				state.currentSession = Session(id: "", user: nil, distance: nil, laps: [])
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
