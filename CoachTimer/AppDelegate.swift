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
			value: { $0.starGazersFeature },
			action: { .user($0) }
		)
		
		self.window?.rootViewController = UINavigationController(rootViewController: rootScene)
				
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}
