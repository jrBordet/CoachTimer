//
//  Application+ActivityFeed.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 30/12/20.
//

import Foundation
import RxComposableArchitecture
import os.log

func activityFeed(
	_ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
	return { state, action, environment in
				
		let mirror = Mirror(reflecting: action)
				
		if let f = mirror.children.first {
			let value = String(reflecting: f.value)
			
			if let sAction = value.components(separatedBy: ".").last {
				os_log("activityFeed action:  %{public}@ ", log: OSLog.activityFeed, type: .info, sAction)

				os_log("activityFeed value: %{public}@ ", log: OSLog.activityFeed, type: .info, value)
			}
		}
		
		return reducer(&state, action, environment)
	}
}

extension OSLog {
	private static var subsystem = Bundle.main.bundleIdentifier!
		
	static let activityFeed = OSLog(subsystem: subsystem, category: "activityFeed")
	
	static let fetch = OSLog(subsystem: subsystem, category: "fetch")
}
