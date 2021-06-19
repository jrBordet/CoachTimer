//
//  FileClient.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 18/06/21.
//

import Foundation

public protocol FileClient {
	var directory: FileManager.SearchPathDirectory { get }
	
	var fileName: String { get }
	
	var content: Data? { get }
}

extension FileClient {
	var filenameUrl: URL? {
		NSSearchPathForDirectoriesInDomains(self.directory, .userDomainMask, true)
			.first
			.map { URL(fileURLWithPath: $0).appendingPathComponent(self.fileName) }
	}
}

internal func eraseDirectory<T: FileClient>(
	_ client: T
) throws -> Void {
	let fileManager = FileManager.default
	let documentsUrl =  fileManager.urls(for: client.directory, in: .userDomainMask).first! as NSURL
	let documentsPath = documentsUrl.path
	
	if let documentPath = documentsPath {
		let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
		
		print("all files in directory: \(fileNames)")
		
		for fileName in fileNames {
			let filePathName = "\(documentPath)/\(fileName)"
			try fileManager.removeItem(atPath: filePathName)
		}
		
		let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
		
		print("all files i after deleting: \(files)")
	}
}

internal func persist<T: FileClient>(
	_ client: T
) throws -> Void {
	guard let fileNameUrl = client.filenameUrl else {
		throw NSError(domain: "FileClient unable to find \(String(describing: client))", code: -1, userInfo: nil)
	}
	
	try client.content?.write(to: fileNameUrl)
}

internal func loadData<T: FileClient>(
	_ client: T
) throws -> Data? {
	try client.filenameUrl.map { try Data(contentsOf: $0) }
}
