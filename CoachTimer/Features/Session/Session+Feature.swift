//
//  Search+Future.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature business logic

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
		
		state.lapsCount = state.laps.count
		state.peakSpeed = peakSpeed(laps: state.laps, distance: state.distance ?? 1)

		return []
	case let .laps(v):
		guard v.isEmpty == false else {
			return []
		}
		
		state.laps = v
		
		state.lapsCount = state.laps.count
		state.peakSpeed = peakSpeed(laps: state.laps, distance: state.distance ?? 1)
		
		return []
		
	case let .name(id):
		state.id = id ?? ""
		
		return []
		
	case .saveCurrentSession:
		state.sessions.append(
			Session(
				id: state.id,
				user: state.user,
				distance: state.distance,
				laps: state.laps
			)
		)
		
		return []
	}
}

// MARK: - Feature domain

public struct SessionState: Equatable  {
	var id: String
	var user: User?
	var distance: Int?
	var laps: [Lap]
	var sessions: [Session]
	var lapsCount: Int
	var peakSpeed: Double
	
	public init(
		id: String,
		user: User?,
		distance: Int?,
		laps: [Lap],
		sessions: [Session],
		lapsCount: Int,
		peakSpeed: Double
	) {
		self.id = id
		self.user = user
		self.distance = distance
		self.laps = laps
		self.sessions = sessions
		self.lapsCount = lapsCount
		self.peakSpeed = peakSpeed
	}
}

extension SessionState {
	static var empty = Self(
		id: "",
		user: nil,
		distance: nil,
		laps: [],
		sessions: [],
		lapsCount: 0,
		peakSpeed: 0
	)
}

public enum SessionAction: Equatable {
	case name(String?)
	case distance(Int?)
	case lap(Lap)
	case laps([Lap])
	case saveCurrentSession
}

public struct SessionEnvironment {
}
