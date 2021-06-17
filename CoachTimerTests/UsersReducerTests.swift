//
//  UsersReducerTests.swift
//  UsersReducerTests
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

class UsersReducerTests: XCTestCase {
	let env_empty = UsersEnvironment(
		fetch: {
			.just([])
		}
	)
	
	let env_filled = UsersEnvironment(
		fetch: {
			.just([
				.sample,
				.sample_1
			])
		}
	)
	
	let env_not_found = UsersEnvironment(
		fetch: {
			.just([
				.notFound
			])
		}
	)
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testUsersEmpty() {
		assert(
			initialValue: UsersState(list: [], isLoading: false, alert: nil, currentUser: nil),
			reducer: usersReducer,
			environment: env_empty,
			steps: Step(.send, UsersAction.fetch, { state in
				state.isLoading = true
			}),
			Step(.receive, UsersAction.fetchResponse([]), { state in
				state.list = []
				state.isLoading = false
			})
		)
	}
	
	func testUsersFilled() {
		assert(
			initialValue: UsersState(list: [], isLoading: false, alert: nil, currentUser: nil),
			reducer: usersReducer,
			environment: env_filled,
			steps: Step(.send, UsersAction.fetch, { state in
				state.isLoading = true
			}),
			Step(.receive, UsersAction.fetchResponse([.sample, .sample_1]), { state in
				state.list = [
					.sample,
					.sample_1
				]
				state.isLoading = false
				state.currentPage = 2
			})
		)
	}
	
	func testUsersFailure() {
		assert(
			initialValue: UsersState(list: [], isLoading: false, alert: nil, currentUser: nil),
			reducer: usersReducer,
			environment: env_not_found,
			steps: Step(.send, UsersAction.fetch, { state in
				state.isLoading = true
			}),
			Step(.receive, UsersAction.fetchResponse([.notFound]), { state in
				state.list = []
				state.alert = "not found"
				state.isLoading = false
				state.currentPage = 1
			})
		)
	}
	
	func testSingleUserSelection() {
		assert(
			initialValue: UsersState.init(list: [], isLoading: false, alert: nil, currentUser: nil),
			reducer: usersReducer,
			environment: env_filled,
			steps: Step(.send, UsersAction.selectUser(.sample), { state in
				state.currentUser = .sample
			})
		)
		
	}
}
