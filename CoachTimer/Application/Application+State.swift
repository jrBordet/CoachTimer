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
	var usersSession: UsersViewState
}

extension AppState: Equatable { }

extension AppState {
	var starGazersFeature: UsersViewState {
		get {
			self.usersSession
		}
		set {
			self.usersSession = newValue
		}
	}
}

let initialAppState = AppState(
	usersSession: .empty
)
