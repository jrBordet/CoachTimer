//
//  Utilities.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 20/06/21.
//

import Foundation

/// https://stackoverflow.com/questions/24051314/precision-string-format-specifier-in-swift/34574966

extension Int {
	func format(f: String) -> String {
		return String(format: "%\(f)d", self)
	}
}

extension Double {
	func format(f: String) -> String {
		return String(format: "%\(f)f", self)
	}
}
