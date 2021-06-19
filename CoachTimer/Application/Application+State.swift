//
//  AppState.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture

public struct AppState {
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
				sort: nil
			)
		}
	}
	
	var leaderboard: LeaderboardState {
		get {
			LeaderboardState(
				sessions: self.usersSession.sessions,
				sort: nil
			)
		}
		
		set {
			self.leaderboardState = newValue
		}
	}
}

let initialAppState = AppState(
	usersSession: .empty,
	leaderboardState: .empty
)
