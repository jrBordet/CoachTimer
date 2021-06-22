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
	
	var sort: Sorting = .speed
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
				sort: self.sort
			)
		}
	}
	
	var leaderboard: LeaderboardState {
		get {
			LeaderboardState(
				sessions: self.usersSession.sessions,
				sort: self.sort
			)
		}
		
		set {
			self.leaderboardState = newValue
			self.sort = newValue.sort
		}
	}
}

let initialAppState = AppState(
	usersSession: .empty,
	leaderboardState: .empty
)
