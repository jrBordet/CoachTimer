//
//  AppReducer.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture
import RxSwift

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =  combine(
	pullback(
		usersSessionsiewReducer,
		value: \AppState.usersSessions,
		action: /AppAction.userSessions,
		environment: { $0.userEnv }
	),
	pullback(
		leaderboardReducer,
		value: \AppState.leaderboardFeature,
		action: /AppAction.leaderboard,
		environment: { $0.leaderboardEnv }
	)
)
