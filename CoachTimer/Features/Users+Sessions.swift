//
//  UsersSessions+View.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

// MARK: - Feature domain

struct UsersSessionsViewState: Equatable {
	var list: [User]
	var isLoading: Bool
	var alert: String?
	var currentPage: Int
	
	var currentUser: User?
	var currentSession: Session?
	var sessions: [Session]
	
	var sort: Sorting
	var exportSuccess: Bool?
	
	init(
		list: [User],
		isLoading: Bool,
		alert: String?,
		currentPage: Int,
		currentUser: User?,
		currentSession: Session?,
		sessions: [Session],
		sort: Sorting,
		exportSuccess: Bool?
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
		self.currentUser = currentUser
		self.currentSession = currentSession
		self.sessions = sessions
		self.sort = sort
		self.exportSuccess = exportSuccess
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
				id: nil,
				user: newValue.currentUser,
				distance: nil,
				laps: [],
				sessions: self.sessions,
				lapsCount: 0,
				peakSpeed: 0,
				sort: .speed,
				exportSuccess: nil
			)
		}
	}
	
	var session: SessionState {
		get {
			SessionState(
				id: self.currentSession?.id ?? nil,
				user: self.currentUser,
				distance: self.currentSession?.distance ?? 0,
				laps: self.currentSession?.laps ?? [],
				sessions: self.sessions,
				lapsCount: self.currentSession?.laps.count ?? 0,
				peakSpeed: peakSpeed(laps: self.currentSession?.laps ?? [], distance: self.currentSession?.distance ?? 1),
				sort: self.sort,
				exportSuccess: self.exportSuccess
			)
		}
		
		set {
			self.currentSession = Session(
				id: newValue.id ?? nil,
				user: newValue.user,
				distance: newValue.distance,
				laps: newValue.laps
			)

			self.sessions = newValue.sessions
			self.sort = newValue.sort
			self.exportSuccess = newValue.exportSuccess
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
		sessions: [],
		sort: .speed,
		exportSuccess: nil
	)
	
	static var sample = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1,
		currentUser: nil,
		currentSession: nil,
		sessions: [],
		sort: .speed,
		exportSuccess: nil
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
		sessions: [],
		sort: .speed,
		exportSuccess: nil
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
		sessions: [],
		sort: .speed,
		exportSuccess: nil
	)
}

enum UsersSessionsViewAction: Equatable {
	case user(UsersAction)
	case session(SessionAction)
}

public struct UsersViewEnvironment {
	var userEnv: UsersEnvironment
	var sessionEnv: SessionEnvironment
}

// MARK: - Business logic

let usersSessionsiewReducer: Reducer<UsersSessionsViewState, UsersSessionsViewAction, UsersViewEnvironment> = combine(
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
		environment: { $0.sessionEnv }
	)
)
