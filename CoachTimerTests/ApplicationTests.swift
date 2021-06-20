//
//  ApplicationTests.swift
//  CoahTimerTests
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
import SceneBuilder

class ApplicationTests: XCTestCase {
	func testApplication() throws {
		// MARK: - App domain
		let usersSessionsState = UsersSessionsViewState(
			list: [],
			isLoading: false,
			alert: nil,
			currentPage: 0,
			currentUser: nil,
			currentSession: nil,
			sessions: []
		)
		
		let leaderboardState = LeaderboardState(
			sessions: [],
			sort: .speed
		)
		
		let appState = AppState(
			usersSession: usersSessionsState,
			leaderboardState: leaderboardState
		)
		
		// MARK: - External dependecies
		
		let usersViewEnvironment = UsersViewEnvironment(
			userEnv: UsersEnvironment(
				fetch: {
					.just([])
				},
				persistUsers: { user -> Effect<Bool> in
					.just(true)
				},
				loadUsers: {
					.just([.sample])
				}
			)
		)
		
		let env = AppEnvironment(
			userEnv: usersViewEnvironment
		)
		
		// MARK: - Tests
		
		assert(
			initialValue: appState,
			reducer: appReducer,
			environment: env,
			steps: Step(.send, .userSessions(.user(.load)), { state in
				state.usersSession.currentSession = Session(
					id: "",
					user: nil,
					distance: nil,
					laps: []
				)
			}),
			Step(.receive, .userSessions(.user(.loadResponse([.sample]))), { state in
				state.usersSession.user.list = [
					.sample
				]
			})
		)
	}
	
}
