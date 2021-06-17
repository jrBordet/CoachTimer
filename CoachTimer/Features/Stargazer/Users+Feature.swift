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
	}
}

// MARK: - Feature domain

public struct UserState {
	let id: String
	let name: String
	let imageUrl: URL?
}

extension UserState: Equatable { }

extension UserState {
	static var notFound = Self(
		id: "notFound",
		name: "not-found",
		imageUrl: nil
	)
	
	static var empty = Self(
		id: "empty",
		name: "",
		imageUrl: nil
	)
	
	static var sample = Self(
		id: "1",
		name: "ryagas",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/553981?v=4")!
	)
	
	static var sample_1 = Self(
		id: "2",
		name: "kjaikeerthi",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/351510?v=4")!
	)
}

public struct UsersState: Equatable {
	var list: [UserState]
	var isLoading: Bool
	var alert: String?
	var currentPage: Int
	
	public init(
		list: [UserState],
		isLoading: Bool,
		alert: String?,
		currentPage: Int = 1
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
}

extension UsersState {
	static var empty = Self(
		list: [],
		isLoading: false,
		alert: nil
	)
}

public enum UsersAction: Equatable {
	case purge
	case fetch
	case fetchResponse([UserState])
}

// MARK: - Environment

public struct UsersEnvironment {
	/// Lists the users
	///
	/// ```
	/// fetch()
	/// ```
	/// - Returns:  a collection of `UserState`.
	var fetch: () -> Effect<[UserState]>
}

