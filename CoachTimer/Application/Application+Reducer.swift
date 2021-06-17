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
		stargazerViewReducer,
		value: \AppState.usersSession,
		action: /AppAction.userSessions,
		environment: { $0.userEnv }
	)
)
