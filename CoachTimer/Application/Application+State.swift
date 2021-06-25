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
	var usersSessions: UsersSessionsViewState
	var leaderboardState: LeaderboardState
}

extension AppState: Equatable { }

extension AppState {
	var usersSessionsFeature: UsersSessionsViewState {
		get {
			self.usersSessions
		}
		
		set {
			self.usersSessions = newValue
						
			self.leaderboardFeature = LeaderboardState(
				sessions: newValue.sessions,
				sort: newValue.sort,
				exportSuccess: newValue.exportSuccess
			)
		}
	}
	
	var leaderboardFeature: LeaderboardState {
		get {
			LeaderboardState(
				sessions: self.usersSessions.sessions,
				sort: self.usersSessions.sort,
				exportSuccess: self.usersSessions.exportSuccess
			)
		}
		
		set {
			self.leaderboardState = newValue
			
			self.usersSessions = UsersSessionsViewState(
				list: self.usersSessions.list,
				isLoading: self.usersSessions.isLoading,
				alert: self.usersSessions.alert,
				currentPage: self.usersSessions.currentPage,
				currentUser: self.usersSessions.currentUser,
				currentSession: self.usersSessions.currentSession,
				sessions: newValue.sessions,
				sort: newValue.sort,
				exportSuccess: newValue.exportSuccess
			)
		}
	}
}

let initialAppState = AppState(
	usersSessions: .empty,
	leaderboardState: .empty
)
