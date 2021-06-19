//
//  UsersSessions+View.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature domain

public struct UsersSessionsViewState: Equatable {
	public var list: [User]
	public var isLoading: Bool
	public var alert: String?
	public var currentPage: Int
	
	public var currentUser: User?
	public var currentSession: Session?
	
	public init(
		list: [User],
		isLoading: Bool,
		alert: String?,
		currentPage: Int,
		currentUser: User?,
		currentSession: Session?
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
		self.currentUser = currentUser
		self.currentSession = currentSession
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
			
			// The session is derived from the user selection
			self.session = SessionState(
				id: "",
				user: newValue.currentUser,
				distance: nil,
				laps: []
			)
		}
	}
	
	var session: SessionState {
		get {
			SessionState(
				id: "",
				user: self.currentUser,
				distance: nil,
				laps: []
			)
		}
		
		set {
			self.currentSession = Session(
				id: newValue.id,
				user: newValue.user,
				distance: newValue.distance,
				laps: newValue.laps
			)
		}
	}
}

extension UsersSessionsViewState {
	static var empty = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil
	)
	
	static var sample = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil
	)
	
	static var sample_1 = Self(
		list: [
			User.sample,
			User.sample_1
		],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil
	)
	
	static var test = Self(
		list: [
			User.sample,
			User.sample_1
		],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil
	)
}

public enum UsersSessionsViewAction: Equatable {
	case user(UsersAction)
	case session(SessionAction)
}

public struct UsersViewEnvironment {
	var userEnv: UsersEnvironment
}

// MARK: - Business logic

public let usersSessionsiewReducer: Reducer<UsersSessionsViewState, UsersSessionsViewAction, UsersViewEnvironment> = combine(
	pullback(
		usersReducer,
		value: \UsersSessionsViewState.user,
		action: /UsersSessionsViewAction.user,
		environment: { $0.userEnv }
	),
	pullback(
		sessionReducer,
		value: \UsersSessionsViewState.session,
		action: /UsersSessionsViewAction.session,
		environment: { _ in SessionEnvironment() }
	)
)
