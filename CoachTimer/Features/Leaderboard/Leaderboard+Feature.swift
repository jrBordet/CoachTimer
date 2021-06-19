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

public func leaderboardReducer(
	state: inout LeaderboardState,
	action: LeaderboardAction,
	environment: LeaderboardEnvironment
) -> [Effect<LeaderboardAction>] {
	switch action {
	case .sort(.speed):
		state.sort = .speed
		
		state.sessions = state.sessions.sorted { s1, s2 in
			s1.speed() > s2.speed()
		}
		
		return []
		
	case .sort(.laps):
		state.sort = .laps
		
		state.sessions = state.sessions.sorted { s1, s2 in
			s1.laps.count > s2.laps.count
		}

		return []
	}
}

// MARK: - Feature domain

public enum Sorting: Equatable {
	case speed
	case laps
}

public struct LeaderboardState: Equatable  {
	var sessions: [Session]
	var sort: Sorting
	
	public init(
		sessions: [Session],
		sort: Sorting
	) {
		self.sessions = sessions
		self.sort = sort
	}
}

extension LeaderboardState {
	static var empty = Self(
		sessions: [],
		sort: .speed
	)
}

public enum LeaderboardAction: Equatable {
	case sort(Sorting)
}

public struct LeaderboardEnvironment {
}
