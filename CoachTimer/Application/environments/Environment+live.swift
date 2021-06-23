//
//  Environment+live.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxComposableArchitecture

// MARK: - Application effetcs

extension AppEnvironment {
	static var live = Self(
		userEnv: .live,
		leaderboardEnv: .live
	)
}

// MARK: Composition of Users and Session environments

extension UsersViewEnvironment {
	static var live = Self(
		userEnv: .live,
		sessionEnv: .live
	)
}

// MARK: Leaderboard

/**
	3) Export

	Provide a sample function that eﬃciently converts data structures to string rows.
	The function should run in parallel without blocking the UI.
*/

let liveExportCSV: ([Session]) -> Effect<Bool> = { sessions in
	 Observable<String>
		.just(exportCSV(sessions))
		.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
		.delay(.seconds(10), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
		.map { _ in true }
}

extension LeaderboardEnvironment {
	static var live = Self(
		exportCSV: {
			liveExportCSV($0)
				.debug("[ExportCSV] result:", trimOutput: false)
		}
	)
}

// MARK: Session

/**

	5) Sync
	automatic sync procedure that pushes a single session to Cloud APIs.

	every time a session is completed the `sync` function is called
*/

extension SessionEnvironment {
	static var live = Self(
		sync: { session in
			let request = SyncRequest(body: session.exportCSV())
						
			return request
				.execute(with: URLSession.shared)
				.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
				.map { $0.status == "training-uploaded" }
				.debug("[SYNC] result:", trimOutput: false)
		}
	)
}

// MARK: Users

extension UsersEnvironment {
	static var live = Self(
		fetch: {
			let request = UsersRequest(
				seed: "empatica",
				results: 10
			)
			
			return request
				.execute(with: URLSession.shared)
				.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
				// TODO: - forgive me, I've introduced a delays just to show the activity indicator
				.delay(.milliseconds(280), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
				.map { (model: SeedUserRequestModel) -> [User] in
					model.results.map { (model: UserRequestModel) -> User in
						User(
							id: model.id(),
							title: model.name.title,
							name: model.name.first,
							surname: model.name.last,
							imageUrl: URL(string:  model.picture.large)!
						)
					}
				}
		},
		persistUsers: { users in
			do {
				let usersEncoded = try JSONEncoder().encode(users)
				
				let file = UserFileClient.live(usersEncoded)
				
				try persist(file)
				
				return .just(true)
			} catch let e {
				return .just(false)
			}
		},
		loadUsers: {
			do {
				guard let data = try loadData(UserFileClient.live()) else {
					return .just([])
				}
				
				let users = try JSONDecoder().decode([User].self, from: data)
				
				return .just(users)
			} catch let e {
				return .just([])
			}
		}
	)
}
