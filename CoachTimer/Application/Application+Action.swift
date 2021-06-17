//
//  AppAction.swift
//  CoachTimer
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case userSessions(UsersSessionsViewAction)
}

extension AppAction: Equatable { }
