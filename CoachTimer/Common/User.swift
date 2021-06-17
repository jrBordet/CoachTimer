//
//  User.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 17/06/21.
//

import Foundation

public struct User: Equatable {
	let id: String
	let name: String
	let imageUrl: URL?
}

extension User {
	static var notFound = Self(
		id: "notFound",
		name: "not-found",
		imageUrl: nil
	)
	
	static var empty = Self(
		id: "empty",
		name: "",
		imageUrl: nil
	)
	
	static var sample = Self(
		id: "1",
		name: "ryagas",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/553981?v=4")!
	)
	
	static var sample_1 = Self(
		id: "2",
		name: "kjaikeerthi",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/351510?v=4")!
	)
}
