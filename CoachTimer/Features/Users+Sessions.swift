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
	public var sessions: [Session]
	
	public init(
		list: [User],
		isLoading: Bool,
		alert: String?,
		currentPage: Int,
		currentUser: User?,
		currentSession: Session?,
		sessions: [Session]
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
		self.currentUser = currentUser
		self.currentSession = currentSession
		self.sessions = sessions
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
				laps: [],
				sessions: self.sessions,
				lapsCount: 0,
				peakSpeed: 0
			)			
		}
	}
	
	var session: SessionState {
		get {
			SessionState(
				id: self.currentSession?.id ?? "",
				user: self.currentUser,
				distance: self.currentSession?.distance ?? 0,
				laps: self.currentSession?.laps ?? [],
				sessions: self.sessions,
				lapsCount: self.currentSession?.laps.count ?? 0,
				peakSpeed: peakSpeed(laps: self.currentSession?.laps ?? [], distance: self.currentSession?.distance ?? 1)
			)
		}
		
		set {
			self.currentSession = Session(
				id: newValue.id,
				user: newValue.user,
				distance: newValue.distance,
				laps: newValue.laps
			)

			self.sessions = newValue.sessions
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
		currentSession: nil,
		sessions: []
	)
	
	static var sample = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil,
		sessions: []
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
		currentSession: nil,
		sessions: []
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
		currentSession: nil,
		sessions: []
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
