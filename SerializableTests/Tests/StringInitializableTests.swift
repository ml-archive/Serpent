//
//  StringInitializableTests.swift
//  Serializable
//
//  Created by Chris Combs on 17/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import UIKit
import XCTest
import Serializable

class StringInitializableTests: XCTestCase {
	var testModel: StringInitializableTestModel!
	
	override func setUp() {
		super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("StringInitializableTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				let bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
				testModel = StringInitializableTestModel(dictionary: bridgedDictionary)
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}
	}
	
	func testNSURL() {
		XCTAssertNotNil(testModel.someUrl, "Failed to create NSURL from string")
		XCTAssertEqual(testModel.someUrl, NSURL(string: "http://www.google.com"), "Failed to parse URL")
		XCTAssertNotNil(testModel.someDate, "Failed to create Date from string")
		XCTAssertEqual(testModel.someDate, Date(string: "2000-01-01T11:22:33"), "Failed to parse Date")
		XCTAssertNil(testModel.someNSDate, "Apparently you fixed NSDate native parsing, so update this test case")
		XCTAssertNil(testModel.someEmptyURL, "Failed to return nil when parsing empty string")
	}
	
}

