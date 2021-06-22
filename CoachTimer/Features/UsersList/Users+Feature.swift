//
//  Stargazer+Feature.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature business logic

func usersReducer(
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
		
		return [
			environment.persistUsers(state.list).map { UsersAction.persistUsersResponse($0) }
		]
		
	case let .selectUser(u):
		state.currentUser = u
		
		return []
		
	case .persistUsersResponse:
		// TODO: - handle persistence error
		return []
		
	case .load:
		return [
			environment.loadUsers().map { UsersAction.loadResponse($0) }
		]
		
	case let .loadResponse(users):
		guard users.isEmpty else {
			state.list = users

			return []
		}
		
		return [
			environment.fetch().map { UsersAction.fetchResponse($0) }
		]
	}
}

// MARK: - Feature domain

struct UsersState: Equatable {
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

enum UsersAction: Equatable {
	case load
	case loadResponse([User])
	case fetch
	case fetchResponse([User])
	case persistUsersResponse(Bool)
	case selectUser(User?)
}

// MARK: - Environment

struct UsersEnvironment {
	/// Lists the users
	///
	/// ```
	/// fetch()
	/// ```
	/// - Returns:  a collection of `User`.
	var fetch: () -> Effect<[User]>
	
	var persistUsers: ([User]) -> Effect<Bool>
	var loadUsers: () -> Effect<[User]>
}

