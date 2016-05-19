//
//  SerializableEntityTests.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import XCTest

class SerializableEntityTests: XCTestCase {
	
	var bridgedDictionary: NSDictionary!
	var testModel: SerializableEntityTestModel!
	
	override func setUp() {
		super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("SerializableEntityTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
				testModel = SerializableEntityTestModel(dictionary: bridgedDictionary)
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}

	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testSerializableParsing() {
		XCTAssertNil(testModel.simple, "Failed to return nil when JSON contains array while struct expects Serializable")
		XCTAssertNotNil(testModel.simples, "Failed to parse array of Serializables")
		XCTAssertNotEqual(testModel.strings.count, 0, "Failed to parse array of primitives")
		XCTAssertEqual(testModel.ints.count, 0, "Failed to parse array of primitives")
		XCTAssertEqual(testModel.stringInts.count, 0, "Failed to create empty array from non dictionary serializable array type")
		XCTAssertEqual(testModel.stringDicts.count, 2, "Failed to create array of empty Serializables from wrong serializable array type")
	}
}