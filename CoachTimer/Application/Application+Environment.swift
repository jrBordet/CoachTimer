//
//  Environment.swift
//  CoachTimer
//

import Foundation
import RxComposableArchitecture
import os.log
import RxSwift

struct AppEnvironment {
	var userEnv: UsersViewEnvironment
	var leaderboardEnv: LeaderboardEnvironment
}
