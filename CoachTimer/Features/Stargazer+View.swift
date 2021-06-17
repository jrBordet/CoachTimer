//
//  Stargazer+View.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

public struct UsersViewState: Equatable {
	public var list: [UserState]
	public var repo: String
	public var owner: String
	public var isLoading: Bool
	public var alert: String?
	public var currentPage: Int
	
	public init(
		list: [UserState],
		repo: String,
		owner: String,
		isLoading: Bool,
		alert: String?,
		currentPage: Int
	) {
		self.list = list
		self.repo = repo
		self.owner = owner
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
	
	var user: UsersState {
		get {
			UsersState(
				list: self.list,
				isLoading: self.isLoading,
				alert: self.alert,
				currentPage: currentPage
			)
		}
		
		set {
			self.list = newValue.list
			self.isLoading = newValue.isLoading
			self.alert = newValue.alert
			self.currentPage = newValue.currentPage
		}
	}
	
	var search: SearchState {
		get {
			SearchState(
				list: self.list,
				repo: self.repo,
				owner: self.owner
			)
		}
		
		set {
			self.list = newValue.list
			self.repo = newValue.repo
			self.owner = newValue.owner
		}
	}
}

extension UsersViewState {
	static var empty = Self(
		list: [],
		repo: "",
		owner: "",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
	
	static var sample = Self(
		list: [],
		repo: "octocat",
		owner: "hello-world",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
	
	static var sample_1 = Self(
		list: [
			UserState.sample,
			UserState.sample_1
		],
		repo: "octocat",
		owner: "hello-world",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
	
	static var test = Self(
		list: [
			UserState.sample,
			UserState.sample_1
		],
		repo: "octocat",
		owner: "hello-world",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
}

public enum UsersViewAction: Equatable {
	case user(UsersAction)
	case search(SearchAction)
}

public struct UsersViewEnvironment {
	var stargazersEnv: UsersEnvironment
}

public let stargazerViewReducer: Reducer<UsersViewState, UsersViewAction, UsersViewEnvironment> = combine(
	pullback(
		usersReducer,
		value: \UsersViewState.user,
		action: /UsersViewAction.user,
		environment: { $0.stargazersEnv }
	),
	pullback(
		searchReducer,
		value: \UsersViewState.search,
		action: /UsersViewAction.search,
		environment: { _ in SearchEnvironment() }
	)
)
