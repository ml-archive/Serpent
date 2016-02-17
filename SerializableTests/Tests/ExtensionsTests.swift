//
//  ExtensionsTests.swift
//  Serializable
//
//  Created by Chris Combs on 17/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable

class ExtensionsTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
		
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

	func testDate() {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		XCTAssertEqual(Date.ISOFormatter.dateFormat, formatter.dateFormat, "Failed to create ISO DateFormatter")
		XCTAssertEqual(Date().encodableRepresentation() as? String, Date().stringRepresentation(), "Failed to get correct encodableRepresentation()")
		XCTAssertNotNil(Date().value, "Failed to create empty Date object")
		
		let nowDate = NSDate()
		XCTAssertEqual(Date(date: nowDate)?.value, nowDate, "Failed to create Date from NSDate")
		
        let fullDateString  = "2016-02-11T10:01:42+0000"
        let midDateString   = "2016-02-11T10:01:42"
        let smallDateString = "2016-02-11"
		
		if let date = Date(string: fullDateString) {
			XCTAssertEqual(date.value, formatter.dateFromString(fullDateString))
			XCTAssertEqual(date.value, Date.dateFromString(fullDateString), "dateFromString failed with full timestamp")
		}
		else {
			XCTFail("Failed to create date object from full timestamp String")
		}
		if let date = Date(string: midDateString) {
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			XCTAssertEqual(date.value, formatter.dateFromString(midDateString))
			XCTAssertEqual(date.value, Date.dateFromString(midDateString), "dateFromString failed with medium timestamp")
		}
		else {
			XCTFail("Failed to create date object from medium timestamp String")
		}
		if let date = Date(string: smallDateString) {
			formatter.dateFormat = "yyyy-MM-dd"
			XCTAssertEqual(date.value, formatter.dateFromString(smallDateString))
			XCTAssertEqual(date.value, Date.dateFromString(smallDateString), "dateFromString failed with small timestamp")
		}
		else {
			XCTFail("Failed to create date object from small time String")
		}
		
		XCTAssertNil(Date.dateFromString("invalid"), "dateFromString failed to return nil with invalid format")
		
	}
    
}
