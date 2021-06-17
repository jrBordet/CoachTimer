//
//  AppAction.swift
//  GithubStargazers
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case user(UsersViewAction)
}

extension AppAction: Equatable { }
