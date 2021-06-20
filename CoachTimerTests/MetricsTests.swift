//
//  MetricsTests.swift
//  CoachTimerTests
//
//  Created by Jean Raphael Bordet on 20/06/21.
//

import XCTest
@testable import CoachTimer

class MetricsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLapSpeed() {
		let lap = Lap(
			id: 0,
			time: 100
		)
		
		let result = lap.speed(distance: 10)
		
		XCTAssertEqual(result, 1.0, accuracy: 0.1)
    }
	
	func testPeakSpeed() {
		let lap = Lap(
			id: 0,
			time: 100
		)
		
		let lap_1 = Lap(
			id: 1,
			time: 150
		)
		
		let lap_2 = Lap(
			id: 2,
			time: 80
		)
		
		let distance = 10
		
		let speed = lap_2.speed(distance: distance)
		
		XCTAssertEqual(speed, 1.2, accuracy: 0.1)
		
		let session = Session(
			id: "test",
			user: .sample,
			distance: 10,
			laps: [
				lap,
				lap_1,
				lap_2
			]
		)
		
		let peakSpeed = session.peakSpeed(distance: distance)
		
		XCTAssertEqual(peakSpeed, 1.2, accuracy: 0.1)
	}
	
	func testPeakSpeed2() {
		let lap = Lap(
			id: 0,
			time: 100
		)
		
		let lap_1 = Lap(
			id: 1,
			time: 150
		)
		
		let lap_2 = Lap(
			id: 2,
			time: 80
		)
		
		let lap_3 = Lap(
			id: 3,
			time: 70
		)
		
		let distance = 10
		
		let speed = lap_2.speed(distance: distance)
		
		XCTAssertEqual(speed, 1.2, accuracy: 0.1)
		
		let session = Session(
			id: "test",
			user: .sample,
			distance: 10,
			laps: [
				lap,
				lap_1,
				lap_2,
				lap_3
			]
		)
		
		let peakSpeed = session.peakSpeedId(distance: distance)
		
		XCTAssertEqual(3, peakSpeed.0)
		XCTAssertEqual(1.4, peakSpeed.1, accuracy: 0.1)
	}

}
