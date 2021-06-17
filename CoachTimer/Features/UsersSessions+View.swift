//
//  UsersSessions+View.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

public struct UsersSessionsViewState: Equatable {
	public var list: [User]
	public var isLoading: Bool
	public var alert: String?
	public var currentPage: Int
	
	public var currentUser: User?
	
	public init(
		list: [User],
		isLoading: Bool,
		alert: String?,
		currentPage: Int,
		currentUser: User?
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
		self.currentUser = currentUser
	}
	
	var user: UsersState {
		get {
			UsersState(
				list: self.list,
				isLoading: self.isLoading,
				alert: self.alert,
				currentPage: self.currentPage,
				currentUser: self.currentUser
			)
		}
		
		set {
			self.list = newValue.list
			self.isLoading = newValue.isLoading
			self.alert = newValue.alert
			self.currentPage = newValue.currentPage
			self.currentUser = newValue.currentUser
		}
	}
	
	var search: SearchState {
		get {
			SearchState(
				list: self.list
			)
		}
		
		set {
			self.list = newValue.list
		}
	}
}

extension UsersSessionsViewState {
	static var empty = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil
	)
	
	static var sample = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil
	)
	
	static var sample_1 = Self(
		list: [
			User.sample,
			User.sample_1
		],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil
	)
	
	static var test = Self(
		list: [
			User.sample,
			User.sample_1
		],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil
	)
}

public enum UsersSessionsViewAction: Equatable {
	case user(UsersAction)
	case search(SearchAction)
}

public struct UsersViewEnvironment {
	var stargazersEnv: UsersEnvironment
}

public let usersSessionsiewReducer: Reducer<UsersSessionsViewState, UsersSessionsViewAction, UsersViewEnvironment> = combine(
	pullback(
		usersReducer,
		value: \UsersSessionsViewState.user,
		action: /UsersSessionsViewAction.user,
		environment: { $0.stargazersEnv }
	),
	pullback(
		searchReducer,
		value: \UsersSessionsViewState.search,
		action: /UsersSessionsViewAction.search,
		environment: { _ in SearchEnvironment() }
	)
)
