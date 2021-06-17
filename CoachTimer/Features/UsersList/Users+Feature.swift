//
//  Stargazer+Feature.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature business logic

public func usersReducer(
	state: inout UsersState,
	action: UsersAction,
	environment: UsersEnvironment
) -> [Effect<UsersAction>] {
	switch action {
	case .fetch:
		state.isLoading = true
		
		return [
			environment.fetch().map { UsersAction.fetchResponse($0) }
		]
		
	case let .fetchResponse(result):
		state.isLoading = false

		guard result.isEmpty == false else {
			return []
		}
		
		if result == [.notFound] {
			state.alert = "not found"
			state.currentPage = 1
			state.list = []
			return []
		} else {
			state.alert = nil
		}
		
		state.list.append(contentsOf: result)
		state.currentPage = state.currentPage + 1
		
		return []
		
	case .purge:
		state.list = []
		state.isLoading = false
		state.alert = nil
		state.currentPage = 1
		
		return []
		
	case let .selectUser(u):
		state.currentUser = u
		
		return []
	}
}

// MARK: - Feature domain

public struct UsersState: Equatable {
	var list: [User]
	var isLoading: Bool
	var alert: String?
	var currentPage: Int
	var currentUser: User?
	
	public init(
		list: [User],
		isLoading: Bool,
		alert: String?,
		currentPage: Int = 1,
		currentUser: User?
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
		self.currentUser = currentUser
	}
}

extension UsersState {
	static var empty = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 0,
		currentUser: nil
	)
}

public enum UsersAction: Equatable {
	case purge
	case fetch
	case fetchResponse([User])
	case selectUser(User)
}

// MARK: - Environment

public struct UsersEnvironment {
	/// Lists the users
	///
	/// ```
	/// fetch()
	/// ```
	/// - Returns:  a collection of `UserState`.
	var fetch: () -> Effect<[User]>
}

