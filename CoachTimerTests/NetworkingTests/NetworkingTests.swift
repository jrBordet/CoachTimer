//
//  ArrivalsTests.swift
//  ViaggioTrenoTests
//
//  Created by Jean Raphael Bordet on 10/12/2020.
//

import XCTest
import RxBlocking
@testable import CoachTimer

class NetworkingTests: XCTestCase {
	var urlSession: URLSession!
	
	override func setUpWithError() throws {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [MockUrlProtocol.self]
		
		urlSession = URLSession(configuration: configuration)
	}
	
	override func tearDownWithError() throws {
	}
	
	func testUserRequest() {
		let request = UsersRequest(
			seed: "empatica",
			results: 10
		)
		
		XCTAssertEqual("https://randomuser.me/api/?seed=empatica&inc=name,picture&gender=male&results=10&noinfo", request.request?.url?.absoluteString)
		XCTAssertEqual("GET", request.request?.httpMethod)
	}
	
	func testSyncRequest() {
		let request = SyncRequest(body: "sample body")
		
		XCTAssertEqual("http://empatica-homework.free.beeceptor.com/trainings", request.request?.url?.absoluteString)
		XCTAssertEqual("POST", request.request?.httpMethod)
	}
	
	func testSyncRequestSuccess() throws {
		MockUrlProtocol.requestHandler = requestHandler(with: "{\n    \"status\": \"training-uploaded\"\n}".data(using: .utf8)!)
		
		let request = SyncRequest(body: "sample body")
		
		let result = try request.execute(
			with: urlSession
		)
		.toBlocking(timeout: 10)
		.toArray()
		.first
		
		XCTAssertEqual("training-uploaded", result?.status)
	}
	
	func testUserRequestSuccess() throws {
		MockUrlProtocol.requestHandler = requestHandler(with: test_success_response.data(using: .utf8)!)
		
		let request = UsersRequest(
			seed: "empatica",
			results: 10
		)
		
		let result = try request
			.execute(with: urlSession)
			.toBlocking(timeout: 10)
			.toArray()
			.first
		
		XCTAssertFalse(result!.results.isEmpty)
		
		XCTAssertEqual(
			result?.results.first,
			UserRequestModel(
				name: UserRequestModel.Name(
					title: "Mr",
					first: "Lucas",
					last: "Harcourt"
				),
				picture: UserRequestModel.Picture(
					large: "https://randomuser.me/api/portraits/men/41.jpg",
					medium: "https://randomuser.me/api/portraits/med/men/41.jpg",
					thumbnail: "https://randomuser.me/api/portraits/thumb/men/41.jpg")
			)
		)
	}
	
	func testUserRequestDecodingError() throws {
		let response = """
		empty_response
		"""
		
		MockUrlProtocol.requestHandler = requestHandler(with: response.data(using: .utf8)!)
		
		let request = UsersRequest(
			seed: "empatica",
			results: 10
		)
		
		do {
			_ = try request
				.execute(with: urlSession)
				.toBlocking(timeout: 10)
				.toArray()
				.first
		} catch let error {
			XCTAssertEqual( APIError.decoding("The data couldn’t be read because it isn’t in the correct format."), error as? APIError)
		}
	}
}


let test_success_response =
"""
{
  "results": [
	{
	  "name": {
		"title": "Mr",
		"first": "Lucas",
		"last": "Harcourt"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/41.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/41.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/41.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Loïs",
		"last": "Jean"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/91.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/91.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/91.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "Bernice",
		"last": "Ward"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/39.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/39.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/39.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mrs",
		"first": "Norma",
		"last": "Middendorf"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/16.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/16.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/16.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "دینا",
		"last": "حیدری"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/60.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/60.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/60.jpg"
	  }
	},
	{
	  "name": {
		"title": "Madame",
		"first": "Audrey",
		"last": "Simon"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/47.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/47.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/47.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Francisco",
		"last": "Webb"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/98.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/98.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/98.jpg"
	  }
	},
	{
	  "name": {
		"title": "Ms",
		"first": "Emma",
		"last": "Rasmussen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/67.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/67.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/67.jpg"
	  }
	},
	{
	  "name": {
		"title": "Mr",
		"first": "Valdemar",
		"last": "Sørensen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/men/51.jpg",
		"medium": "https://randomuser.me/api/portraits/med/men/51.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/men/51.jpg"
	  }
	},
	{
	  "name": {
		"title": "Miss",
		"first": "Freja",
		"last": "Andersen"
	  },
	  "picture": {
		"large": "https://randomuser.me/api/portraits/women/78.jpg",
		"medium": "https://randomuser.me/api/portraits/med/women/78.jpg",
		"thumbnail": "https://randomuser.me/api/portraits/thumb/women/78.jpg"
	  }
	}
  ]
}
"""
