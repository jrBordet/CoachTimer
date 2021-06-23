//
//  LeaderboardTests.swift
//  CoachTimerTests
//
//  Created by Jean Raphael Bordet on 19/06/21.
//

import XCTest
@testable import CoachTimer
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxComposableArchitectureTests
import SnapshotTesting

class LeaderboardTests: XCTestCase {
	let env = LeaderboardEnvironment(
		exportCSV: { _ in
			.just(true)
		}
	)
	
	func testLeaderboardSorting() throws {		
		assert(
			initialValue: LeaderboardState(
				sessions: [
					Session.one,
					Session.two
				],
				sort: .speed,
				exportSuccess: false
			),
			reducer: leaderboardReducer,
			environment: env,
			steps: Step(.send, LeaderboardAction.sort(.laps), { state in
				state.sort = .laps
				state.sessions = [
					.two,
					.one
				]
			}), Step(.send, LeaderboardAction.sort(.speed), { state in
				state.sort = .speed
				state.sessions = [
					.one,
					.two
				]
			})
		)
	}
	
	func testLeaderboardExportCSV() throws {
		assert(
			initialValue: LeaderboardState(
				sessions: [
					Session.one,
					Session.two
				],
				sort: .speed,
				exportSuccess: false
			),
			reducer: leaderboardReducer,
			environment: env,
			steps: Step(.send, LeaderboardAction.sort(.laps), { state in
				state.sort = .laps
				state.sessions = [
					.two,
					.one
				]
			}),
			Step(.send, .exportCSV, { state in
				
			}),
			Step(.receive, .exportCSVResponse(true), { state in
				state.exportSuccess = true
			})
		)
	}
	
}
