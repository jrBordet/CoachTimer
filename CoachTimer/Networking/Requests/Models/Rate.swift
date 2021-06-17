//
//  Rate.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 27/01/21.
//

import Foundation

public struct Rate: Codable, Equatable {
	public let id: String
	public let fuelName: String
	public let rate: Double
	public let date: Date
	
	public init(_ id: String, fuelName: String, rate: Double, date: Date) {
		self.id = id
		self.fuelName = fuelName
		self.rate = rate
		self.date = date
	}
}
