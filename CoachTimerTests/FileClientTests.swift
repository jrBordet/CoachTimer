//
//  FileClientTests.swift
//  CoachTimerTests
//
//  Created by Jean Raphael Bordet on 18/06/21.
//

import XCTest
@testable import CoachTimer

class FileClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
		let file = UserFileClient.test("".data(using: .utf8)!)
		
		try eraseDirectory(file)
    }
	
	func testPersistence() throws {
		let file = UserFileClient.test("persiste me just some random string".data(using: .utf8)!)
		
		try persist(file)
	}
	
	func testLoadCache() throws {
		let file = UserFileClient.test("persiste me just some random string".data(using: .utf8)!)
		
		try persist(file)
		
		XCTAssertNotNil(try loadData(file))
	}
}
