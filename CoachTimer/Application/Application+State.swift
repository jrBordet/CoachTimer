//
//  AppState.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture

public struct AppState {
	var user: UsersViewState
}

extension AppState: Equatable { }

extension AppState {
	var starGazersFeature: UsersViewState {
		get {
			self.user
		}
		set {
			self.user = newValue
		}
	}
}

let initialAppState = AppState(
	user: .empty
)
