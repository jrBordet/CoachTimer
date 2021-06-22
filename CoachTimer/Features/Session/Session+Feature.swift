//
//  Search+Future.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature business logic

func sessionReducer(
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
		
	case let .id(id):
		state.id = id
		
		return []
		
	case let .saveCurrentSession(date):
		let session = Session(
			id: date,
			user: state.user,
			distance: state.distance,
			laps: state.laps
		)
		
		guard state.laps.count > 0 else {
			return []
		}
		
		state.sessions.append(
			session
		)
				
		return [
			environment.sync(session).map(SessionAction.syncResponse)
		]
		
	case .syncResponse:
		return []
	}
}

// MARK: - Feature domain

struct SessionState: Equatable  {
	var id: Date?
	var user: User?
	var distance: Int?
	var laps: [Lap]
	var sessions: [Session]
	var lapsCount: Int
	var peakSpeed: Double
	
	public init(
		id: Date?,
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
		id: nil,
		user: nil,
		distance: nil,
		laps: [],
		sessions: [],
		lapsCount: 0,
		peakSpeed: 0
	)
}

enum SessionAction: Equatable {
	case id(Date?)
	case distance(Int?)
	case lap(Lap)
	case laps([Lap])
	case saveCurrentSession(Date)
	case syncResponse(Bool)
}

struct SessionEnvironment {
	var sync: (Session) -> Effect<Bool>
}
