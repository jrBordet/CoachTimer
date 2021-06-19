//
//  AppAction.swift
//  CoachTimer
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case userSessions(UsersSessionsViewAction)
	case leaderboard(LeaderboardAction)
}

extension AppAction: Equatable { }
