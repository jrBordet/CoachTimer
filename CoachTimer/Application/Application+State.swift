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
	var sessions: [Session]
}

extension AppState: Equatable { }

extension AppState {
	var usersSessionsFeature: UsersSessionsViewState {
		get {
			self.usersSession
		}
		set {
			self.usersSession = newValue
			self.sessions = newValue.sessions
		}
	}
	
//	var leaderboard:
}

let initialAppState = AppState(
	usersSession: .empty,
	sessions: []
)
