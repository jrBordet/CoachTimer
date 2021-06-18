//
//  Search+Future.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

public func searchReducer(
	state: inout SessionState,
	action: SessionAction,
	environment: SearchEnvironment
) -> [Effect<SessionAction>] {
	switch action {
	case let .distance(v):
		state.distance = v
		return []
		
	}
}

// MARK: - State

public struct SessionState  {
	var user: User?
	var distance: Int?
	
	public init(
		user: User?,
		distance: Int?
	) {
		self.user = user
		self.distance = distance
	}
}

extension SessionState {
	static var empty = Self(
		user: nil,
		distance: nil
	)
}

// MARK: - Action

public enum SessionAction: Equatable {
	case distance(Int?)
}

// MARK: - Environment

public struct SearchEnvironment {
}
