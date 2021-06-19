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
		
		leaderboard.store = Store(
			initialValue: LeaderboardState(sessions: [
				Session.one,
				.two,
				.three
			],
			sort: .speed
			),
			reducer: leaderboardReducer,
			environment: LeaderboardEnvironment()
		)
		
		let tabBarController = UITabBarController()
		
		let item1 = UITabBarItem(title: "Home", image: UIImage(named: ""), tag: 0)
		let item2 = UITabBarItem(title: "Leaderboard", image:  UIImage(named: ""), tag: 1)
		
		homeScene.tabBarItem = item1
		leaderboard.tabBarItem = item2
		
		tabBarController.setViewControllers([
			homeScene,
			leaderboard
		], animated: false)
		
		self.window?.rootViewController = tabBarController
		
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}
