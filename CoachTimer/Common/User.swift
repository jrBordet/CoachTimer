//
//  User.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 17/06/21.
//

import Foundation

public struct Lap: Equatable {
	let id: Int
	let time: Int
}

extension Lap {
	static var lap_0 = Self(
		id: 0,
		time: 10000
	)
	
	static var lap_1 = Self(
		id: 1,
		time: 15000
	)
	
	static var lap_2 = Self(
		id: 2,
		time: 8000
	)
}

public struct Session: Equatable {
	let id: String
	let user: User?
	let distance: Int?
	let laps: [Lap]
}

public struct User: Equatable, Codable {
	let id: String
	let title: String
	let name: String
	let surname: String
	let imageUrl: URL?
}

extension User {
	static var notFound = Self(
		id: "notFound",
		title: "",
		name: "not-found",
		surname: "",
		imageUrl: nil
	)
	
	static var empty = Self(
		id: "empty",
		title: "",
		name: "",
		surname: "",
		imageUrl: nil
	)
	
	static var sample = Self(
		id: "1",
		title: "",
		name: "ryagas",
		surname: "",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/553981?v=4")!
	)
	
	static var sample_1 = Self(
		id: "2",
		title: "",
		name: "kjaikeerthi",
		surname: "",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/351510?v=4")!
	)
}
