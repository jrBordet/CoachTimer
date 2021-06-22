//
//  FileClient+User.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 18/06/21.
//

import Foundation

public struct UserFileClient: FileClient {
	public var content: Data?
	
	public var directory: FileManager.SearchPathDirectory
	
	public var fileName: String
	
	public init(
		content: Data? = nil,
		directory: FileManager.SearchPathDirectory = .documentDirectory,
		fileName: String = ""
	) {
		self.content = content
		self.directory = directory
		self.fileName = fileName
	}
}

extension UserFileClient {
	public static func live(_ value: Data? = nil) -> Self {
		let file = UserFileClient(
			content: value,
			directory: FileManager.SearchPathDirectory.documentDirectory,
			fileName: "users_live.json"
		)

		return file
	}
	
	public static func test(_ value: Data) -> Self {
		let file = UserFileClient(
			content: value,
			directory: FileManager.SearchPathDirectory.cachesDirectory,
			fileName: "users_test.json"
		)
		
		return file
	}
	
}
