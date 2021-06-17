//
//  StargazerRequest.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation

/**

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
	}
]

*/

public struct SeedUserRequestModel: Codable, Equatable {
	public let results: [UserRequestModel]
}

public struct UserRequestModel: Codable, Equatable {
	public let name: Name
	public let picture: Picture
	
	public struct Name: Codable, Equatable {
		public let title: String
		public let first: String
		public let last: String
	}
	
	public struct Picture: Codable, Equatable {
		public let large: String
		public let medium: String
		public let thumbnail: String
	}
	
	func id() -> String {
		(self.name.title + self.name.first + self.name.last).lowercased()
	}
}

/// Refrences ...
/// Example:
/// [Url ecample](https://randomuser.me/api/?seed=empatica&inc=name,picture&gender=male&results=10&noinfo)
/// Mon Nov 20 2017 17:30:00 GMT+0100
///
/// - Parameters:
///   - page: the page index
/// - Returns: a collection of UserRequestModel

public struct UsersRequest: APIRequest, CustomDebugStringConvertible {
	public var debugDescription: String {
		request.debugDescription
	}
	
	public typealias Response = SeedUserRequestModel
	
	public var endpoint: String = "api"
	
	private (set) var seed: String
	private (set) var results: Int
	private (set) var page: Int
	
	public var request: URLRequest? {
		guard let url = URL(string: "https://randomuser.me/\(endpoint)/?seed=\(seed)&inc=name,picture&gender=male&results=\(results)&noinfo") else {
			return nil
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
				
		return request
	}
	
	public init(
		seed: String,
		results: Int,
		page: Int = 1
	) {
		self.seed = seed
		self.results = results
		self.page = page
	}
}
