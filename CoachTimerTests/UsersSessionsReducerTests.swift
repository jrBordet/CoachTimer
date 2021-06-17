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
		stargazersEnv: UsersEnvironment(fetch: {
			.just([
				.sample,
				.sample_1
			])
		})
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
			}),
			Step(.receive, UsersSessionsViewAction.user(UsersAction.fetchResponse([.sample, .sample_1])), { state in
				state.list = [
					.sample,
					.sample_1
				]
				
				state.currentPage = 2
				
				state.isLoading = false
			})
		)
		
	}
}
