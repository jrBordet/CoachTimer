//
//  Mock+.swift
//  ViaggioTreno
//
//  Created by Jean Raphael Bordet on 23/12/2020.
//

import Foundation

extension Data {
	static var sample: Data? {
		data(from: "sample", type: ".json")
	}
	
	private static func data(from file: String, type: String) -> Data? {
		Bundle.main
			.path(forResource: file, ofType: type)
			.map (URL.init(fileURLWithPath:))
			.flatMap { try? Data(contentsOf: $0) }
	}
}
