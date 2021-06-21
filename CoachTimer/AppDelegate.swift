//
//  AppDelegate.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 17/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import UIKit
import RxComposableArchitecture
import SceneBuilder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		let rootScene = Scene<UsersListViewController>().render()
		
		rootScene.store = applicationStore.view(
			value: { $0.usersSessionsFeature },
			action: { .userSessions($0) }
		)
		
		let homeScene = UINavigationController(rootViewController: rootScene)
		
		let leaderboard = Scene<LeaderboardViewController>().render()
		
		leaderboard.store = applicationStore.view(
			value: { $0.leaderboard },
			action: { .leaderboard($0) }
		)
		
//		leaderboard.store = Store(
//			initialValue: LeaderboardState(sessions: [
//				Session.one,
//				.two,
//				.three
//			],
//			sort: .speed
//			),
//			reducer: leaderboardReducer,
//			environment: LeaderboardEnvironment()
//		)
		
		let chart = Scene<SessionChartViewController>().render()
		
		/// 	public var store: Store<SessionState, SessionAction>?

		let sessionStore = Store<SessionState, SessionAction>(
			initialValue: SessionState(
				id: "",
				user: User.sample,
				distance: 100,
				laps: [.lap_0, .lap_1, .lap_2],
				sessions: [],
				lapsCount: 2,
				peakSpeed: 100
			),
			reducer: sessionReducer,
			environment: SessionEnvironment(sync: { sessio in
				.just(true)
			})
		)
		
		chart.store = sessionStore
		
		let tabBarController = UITabBarController()
		
		let item1 = UITabBarItem(title: "Home", image: UIImage(named: ""), tag: 0)
		let item2 = UITabBarItem(title: "Leaderboard", image:  UIImage(named: ""), tag: 1)
		let item3 = UITabBarItem(title: "chart", image:  UIImage(named: ""), tag: 1)

		homeScene.tabBarItem = item1
		leaderboard.tabBarItem = item2
		chart.tabBarItem = item3
		
		tabBarController.setViewControllers([
			homeScene,
			leaderboard,
			chart
		], animated: false)
		
		self.window?.rootViewController = tabBarController
		
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}
