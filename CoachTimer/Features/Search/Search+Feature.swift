//
//  Search+Future.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

public func searchReducer(
	state: inout SearchState,
	action: SearchAction,
	environment: SearchEnvironment
) -> [Effect<SearchAction>] {
	switch action {
	case let .owner(v):
		
		return []
		
	case let .repo(v):
		
		return []
	}
}

// MARK: - State

public struct SearchState  {
	var list: [User]
	
	public init(
		list: [User]
	) {
		self.list = list
	}
}

extension SearchState {
	static var empty = Self(
		list: []
	)
}

// MARK: - Action

public enum SearchAction: Equatable {
	case owner(String)
	case repo(String)
}

// MARK: - Environment

public struct SearchEnvironment {
}
