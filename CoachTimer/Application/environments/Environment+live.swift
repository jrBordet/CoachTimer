//
//  Environment+live.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxSwift
import RxCocoa

// MAK - App

extension AppEnvironment {
	static var live = Self(
		userEnv: UsersViewEnvironment.live
	)
}

// MARK: - View (features composition)

extension UsersViewEnvironment {
	static var live = Self(
		stargazersEnv: UsersEnvironment.live
	)
}

extension UsersEnvironment {
	static var live = Self(
		fetch: {
			let request = UsersRequest(
				seed: "empatica",
				results: 10
			)
			
			return request
				.execute(with: URLSession.shared)
				.map { (model: SeedUserRequestModel) -> [UserState] in
					model.results.map { (model: UserRequestModel) -> UserState in
						UserState(
							id: model.id(),
							name: model.name.first,
							imageUrl: URL(string:  model.picture.large)!
						)
					}
				}
		}
	)
}
