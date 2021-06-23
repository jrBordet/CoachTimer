//
//  SeedUserRequestModel.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 17/06/21.
//

import Foundation

public struct SessionModel: Codable, Equatable {
	public var username: String
	public var peakSpeed: Double
}

public struct SessionRequestModel: Codable, Equatable {
	public let session: SessionModel
}

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

public struct SyncRequestResponse: Codable, Equatable {
	public let status: String
}
