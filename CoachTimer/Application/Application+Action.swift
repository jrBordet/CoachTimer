//
//  AppAction.swift
//  CoachTimer
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case userSessions(UsersViewAction)
}

extension AppAction: Equatable { }
