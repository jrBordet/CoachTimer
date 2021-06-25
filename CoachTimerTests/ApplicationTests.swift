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
			sessions: [],
			sort: .speed,
			exportSuccess: nil
		)
		
		let leaderboardState = LeaderboardState(
			sessions: [],
			sort: .speed,
			exportSuccess: false
		)
		
		let appState = AppState(
			usersSessions: usersSessionsState,
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
			),
			sessionEnv: SessionEnvironment(
				sync: { (s: Session) -> Effect<Bool> in
					.just(true)
				}
			)
		)
		
		let leaderboardEnv = LeaderboardEnvironment(exportCSV: { _ in .just(true) })
		
		let env = AppEnvironment(
			userEnv: usersViewEnvironment,
			leaderboardEnv: leaderboardEnv
		)
		
		// MARK: - Tests
		
		assert(
			initialValue: appState,
			reducer: appReducer,
			environment: env,
			steps: Step(.send, .userSessions(.user(.load)), { state in
				state.usersSessions.currentSession = Session(
					id: nil,
					user: nil,
					distance: nil,
					laps: []
				)
			}),
			Step(.receive, .userSessions(.user(.loadResponse([.sample]))), { state in
				state.usersSessions.user.list = [
					.sample
				]
			}),
			Step(.send, .leaderboard(.sort(.speed)),{ state in
				state.leaderboardState.exportSuccess = nil
			})
		)
	}
	
}
