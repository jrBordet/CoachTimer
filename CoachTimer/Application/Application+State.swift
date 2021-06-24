//
//  AppState.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture

struct AppState {
	var usersSession: UsersSessionsViewState
	var leaderboardState: LeaderboardState
}

extension AppState: Equatable { }

extension AppState {
	var usersSessionsFeature: UsersSessionsViewState {
		get {
			self.usersSession
		}
		
		set {
			self.usersSession = newValue
						
			self.leaderboard = LeaderboardState(
				sessions: newValue.sessions,
				sort: newValue.sort,
				exportSuccess: newValue.exportSuccess
			)
		}
	}
	
	var leaderboard: LeaderboardState {
		get {
			LeaderboardState(
				sessions: self.usersSession.sessions,
				sort: self.usersSession.sort,
				exportSuccess: self.usersSession.exportSuccess
			)
		}
		
		set {
			self.leaderboardState = newValue
			
			self.usersSession = UsersSessionsViewState(
				list: self.usersSession.list,
				isLoading: self.usersSession.isLoading,
				alert: self.usersSession.alert,
				currentPage: self.usersSession.currentPage,
				currentUser: self.usersSession.currentUser,
				currentSession: self.usersSession.currentSession,
				sessions: newValue.sessions,
				sort: newValue.sort,
				exportSuccess: newValue.exportSuccess
			)
		}
	}
}

let initialAppState = AppState(
	usersSession: .empty,
	leaderboardState: .empty
)
