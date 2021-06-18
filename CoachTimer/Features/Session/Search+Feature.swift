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
	case let .owner(v):
		
		return []
	}
}

// MARK: - State

public struct SessionState  {
	var user: User?
	
	public init(
		user: User?
	) {
		self.user = user
	}
}

extension SessionState {
	static var empty = Self(
		user: nil
	)
}

// MARK: - Action

public enum SessionAction: Equatable {
	case owner(String)
}

// MARK: - Environment

public struct SearchEnvironment {
}
