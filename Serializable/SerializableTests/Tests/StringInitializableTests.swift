//
//  StringInitializableTests.swift
//  Serializable
//
//  Created by Chris Combs on 17/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable

class StringInitializableTests: XCTestCase {
	var testModel: StringInitializableTestModel!
	
	override func setUp() {
		super.setUp()
		do {
			if let path = Bundle(for: type(of: self)).path(forResource: "StringInitializableTest", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
				let bridgedDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
				testModel = StringInitializableTestModel(dictionary: bridgedDictionary)
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}
	}
	
	func testNSURL() {
		XCTAssertNotNil(testModel.someUrl, "Failed to create NSURL from string")
		XCTAssertEqual(testModel.someUrl, URL(string: "http://www.google.com"), "Failed to parse URL")
		XCTAssertNil(testModel.someEmptyURL, "Failed to return nil when parsing empty string")
        XCTAssertEqual(testModel.someUrl?.stringRepresentation(), "http://www.google.com", "String representation of URL differs.")
	}

    func testNSDate() {
        XCTAssertEqual(testModel.someDate, Date(timeIntervalSince1970: 145811834), "Failed to parse NSDate")
        XCTAssertNil(testModel.someEmptyDate, "Failed to return nil when parsing empty date")
        XCTAssertNil(testModel.someBadDate, "Failed to return nil when parsing bad date")
        XCTAssertEqual(Date.fromString(testModel.someDate?.stringRepresentation() ?? ""), testModel.someDate, "String representation of URL differs.")
    }
    
    func testNSURLEncoding() {
        guard let encodedModel = testModel.encodableRepresentation() as? NSDictionary else { XCTFail("encodableRepresentation() Failed"); return }
        
        if let someUrl = encodedModel["some_url"] as? String {
            XCTAssertEqual(someUrl, "http://www.google.com", "Failed to encode NSURL to String")
        } else {
            XCTFail("Failed to encode NSURL to String")
        }
    }
    
    func testNSDateEncoding() {
        guard let encodedModel = testModel.encodableRepresentation() as? NSDictionary else { XCTFail("encodableRepresentation() Failed"); return }
        
        if let someDateString = encodedModel["some_date"] as? String {
            let someDate = DateFormatter().date(from: someDateString)
            XCTAssertEqual(someDate, DateFormatter().date(from: "1974-08-15T15:17:14+00:00"), "Failed to encode NSDate to String")
        } else {
            XCTFail("Failed to encode NSDate to String")
        }
    }
}

