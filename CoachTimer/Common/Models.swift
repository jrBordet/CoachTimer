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
	
	
	/// Compute the speed of a single lap
	/// - Parameter d: an Int that represents the distance in meters
	/// - Returns: a Double
	func speed(distance d: Int) -> Double {
		let sec: Double = Double(time) / 10.0 // the timer is on 100 ms
		let d = Double(d)
		return d / sec
	}
	
	func timeInSec() -> Double {
		Double(time) / 10.0
	}
}

func averageSpeed(_ laps: [Lap], distance: Int) -> Double {
	let sum = laps
		.map { $0.speed(distance: distance) }
		.reduce(0, +)
	
	return sum / Double(laps.count)
}

// In statistica, con riferimento a una serie di valori, la media dei quadrati degli scarti dei singoli valori dalla loro media aritmetica.

func timeVariance(_ laps: [Lap], distance: Int) -> Double {
	let sum = laps
		.map { $0.timeInSec() }
		.reduce(0, +)
	
	let avg = sum / Double(laps.count)
	
	let a1 = laps
		.map { $0.timeInSec() }
		.reduce(0) { (result: Double, v: Double) -> Double in
			pow(v - avg, 2)
		}
	
	return a1 / Double(laps.count)
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
	
	func peakSpeed() -> Double {
		guard let distance = distance else {
			return 0
		}
		
		return peakSpeedId(distance: distance).1
	}
	
	
	/// Compute the peak speed froma a Session
	/// - Parameter d: an Int that represents the distance in meters
	/// - Returns: a touple composed by the Id of the lap and the peak speed
	func peakSpeedId(distance d: Int = 1) -> (Int, Double) {
		let result = laps
			.sorted { (l0, l1) -> Bool in
				l0.speed(distance: d) > l1.speed(distance: 1)
			}
			.first
			.map { (lap: Lap) -> (Int, Double) in
				(lap.id, lap.speed(distance: d))
			}
		
		return result ?? (0, 0)
	}
}

func peakSpeed(laps: [Lap], distance: Int) -> Double {
	let result = laps
		.sorted { (l0, l1) -> Bool in
			l0.speed(distance: distance) > l1.speed(distance: distance)
		}
		.first
		.map { (lap: Lap) -> Double in
			lap.speed(distance: distance)
		}
	
	return result ?? 0
}

extension Session {
	static var one = Self(
		id: "one",
		user: .sample,
		distance: 100,
		laps: [
			Lap.lap_0
		]
	)
	
	static var two = Self(
		id: "two",
		user: .sample_1,
		distance: 100,
		laps: [
			.lap_0,
			.lap_1
		]
	)
	
	static var three = Self(
		id: "three",
		user: .sample_1,
		distance: 100,
		laps: [
			.lap_0,
			.lap_1,
			.lap_2
		]
	)
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
