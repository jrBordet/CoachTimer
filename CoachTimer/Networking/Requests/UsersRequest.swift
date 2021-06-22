//
//  UserRequest.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation

/// .
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
