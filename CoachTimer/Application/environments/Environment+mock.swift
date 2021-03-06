//
//  Environment+mock.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 25/05/21.
//

import Foundation

// MAK - App

extension AppEnvironment {
	static var mock = Self(
		userEnv: UsersViewEnvironment.mock,
		leaderboardEnv: LeaderboardEnvironment.mock
	)
}

// MARK: - View (features composition)

extension UsersViewEnvironment {
	static var mock = Self(
		userEnv: .mock,
		sessionEnv: .mock
	)
}

extension SessionEnvironment {
	static var mock = Self(
		sync: { session in
			.just(true)
		}
	)
}

// MARK: - Leaderboard

extension LeaderboardEnvironment {
	static var mock = Self(
		exportCSV: { _ in
			.just(true)
		}
	)
}

// MARK: - Single feature

extension UsersEnvironment {
	static var mock = Self(
		fetch: {
			// not found response
			// return .just([.notFound])
				
			.just(Page()
					.mock(from: page_1)
					.results
					.map { $0.map() })
		},
		persistUsers: { users in
			.just(true)
		},
		loadUsers: {
			.just([])
		}
	)
}

extension UserRequestModel {
	func map() -> User {
		User(
			id: self.id(),
			title: self.name.title,
			name: self.name.first,
			surname: self.name.last,
			imageUrl: URL(string: self.picture.thumbnail)!
		)
	}
}

struct Page: Mockable {
	typealias Model = SeedUserRequestModel
}

protocol Mockable {
	associatedtype Model: Codable
}

extension Mockable {
	func mock(from content: String) -> Model {
		do {
			return try JSONDecoder().decode(Model.self, from: content.data(using: .utf8)!)
		} catch {
			fatalError()
		}
		
	}
	
}

let page_1 =
	"""
{
  "results": [
	{
	  "name": {
		"title": "Mr",
		"first": "Lucas",
		"last": "Harcourt"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/41.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/41.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/41.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Loïs",
		"last": "Jean"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/91.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/91.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/91.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "Bernice",
		"last": "Ward"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/39.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/39.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/39.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mrs",
		"first": "Norma",
		"last": "Middendorf"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/16.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/16.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/16.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "دینا",
		"last": "حیدری"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/60.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/60.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/60.jpg"
	  }
	},
	{
	  "name": {
		"title": "Madame",
		"first": "Audrey",
		"last": "Simon"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/47.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/47.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/47.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Francisco",
		"last": "Webb"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/98.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/98.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/98.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "Emma",
		"last": "Rasmussen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/67.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/67.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/67.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Valdemar",
		"last": "Sørensen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/51.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/51.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/51.jpg"
	  }
	},
	{
	  "name": {
		"title": "Miss",
		"first": "Freja",
		"last": "Andersen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/78.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/78.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/78.jpg"
	  }
	}
  ]
}
"""
