//
//  Search+Future.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

public func sessionReducer(
	state: inout SessionState,
	action: SessionAction,
	environment: SessionEnvironment
) -> [Effect<SessionAction>] {
	switch action {
	case let .distance(v):
		state.distance = v
		return []
		
	case let .lap(v):
		state.laps.append(v)
		
		return []
	case let .laps(v):
		state.laps = v
		
		return []
		
	}
}

// MARK: - State

public struct SessionState: Equatable  {
	var user: User?
	var distance: Int?
	var laps: [Lap]
	
	public init(
		user: User?,
		distance: Int?,
		laps: [Lap]
	) {
		self.user = user
		self.distance = distance
		self.laps = laps
	}
}

extension SessionState {
	static var empty = Self(
		user: nil,
		distance: nil,
		laps: []
	)
}

// MARK: - Action

public enum SessionAction: Equatable {
	case distance(Int?)
	case lap(Lap)
	case laps([Lap])
}

// MARK: - Environment

public struct SessionEnvironment {
}
