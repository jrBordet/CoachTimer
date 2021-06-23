//
//  Leaderboard+Feature.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 19/06/21.
//

import Foundation

import Foundation
import RxComposableArchitecture

// MARK: - Feature business logic

func leaderboardReducer(
	state: inout LeaderboardState,
	action: LeaderboardAction,
	environment: LeaderboardEnvironment
) -> [Effect<LeaderboardAction>] {
	switch action {
	case .sort(.speed):
		state.sort = .speed
		
		state.sessions = state.sessions.sorted { s1, s2 in
			s1.peakSpeed() > s2.peakSpeed()
		}
		
		return []
		
	case .sort(.laps):
		state.sort = .laps
		
		state.sessions = state.sessions.sorted { s1, s2 in
			s1.laps.count > s2.laps.count
		}

		return []
		
	case .exportCSV:
		return [
			environment.exportCSV(state.sessions).map { .exportCSVResponse($0) }
		]
		
	case let .exportCSVResponse(success):
		state.exportSuccess = success
				
		return []
		
	case .resetExport:
		state.exportSuccess = nil
		
		return []
	}
}

// MARK: - Feature domain

enum Sorting: Equatable {
	case speed
	case laps
}

struct LeaderboardState: Equatable  {
	var sessions: [Session]
	var sort: Sorting
	var exportSuccess: Bool?
	
	public init(
		sessions: [Session],
		sort: Sorting,
		exportSuccess: Bool?
	) {
		self.sessions = sessions
		self.sort = sort
		self.exportSuccess = exportSuccess
	}
}

extension LeaderboardState {
	static var empty = Self(
		sessions: [],
		sort: .speed,
		exportSuccess: false
	)
}

enum LeaderboardAction: Equatable {
	case sort(Sorting)
	case exportCSV
	case exportCSVResponse(Bool)
	case resetExport
}

struct LeaderboardEnvironment {
	var exportCSV: ([Session]) -> Effect<Bool>
}
