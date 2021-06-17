//
//  AppStore.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture
import SwiftPrettyPrint

#if MOCK
var applicationStore: Store<AppState, AppAction> =
  Store(
	initialValue: initialAppState,
	reducer: with(
	  appReducer,
	  compose(
		customLogging,
		activityFeed
	)),
	environment: AppEnvironment.mock
)
#else
var applicationStore: Store<AppState, AppAction> =
  Store(
	initialValue: initialAppState,
	reducer: with(
	  appReducer,
	  compose(
		customLogging,
		activityFeed
	)),
	environment: AppEnvironment.live
)
#endif


public func customLogging<Value, Action, Environment>(
	_ reducer: @escaping Reducer<Value, Action, Environment>
) -> Reducer<Value, Action, Environment> {
	return { value, action, environment in
		let effects = reducer(&value, action, environment)
		let _value = value
		return [.fireAndForget {
			print("\n---")

			Pretty.prettyPrint(Date())
			
			print("\n")

			Pretty.prettyPrint(_value)
			
			}] + effects
	}
}
