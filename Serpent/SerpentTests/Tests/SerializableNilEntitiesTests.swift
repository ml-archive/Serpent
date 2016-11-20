//
//  SerializableNilEntitiesTests.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import XCTest


class SerializableNilEntitiesTests: XCTestCase {
	var testModel: NilModel!
	
	override func setUp() {
		super.setUp()
		testModel = NilModel(dictionary: nil)
	}
	
	func testNilPrimitives() {
		XCTAssertEqual(testModel.id, 0, "Guard statement failed for primitive with nil Dictionary")
		XCTAssertNil(testModel.optionalId, "Guard statement failed for optional primitive with nil Dictionary")
		XCTAssertNotNil(testModel.somePrimitiveArray, "Guard statement failed for Primitive array with nil dictionary")
		XCTAssertEqual(testModel.somePrimitiveArray.count, 0, "Guard statement failed for Primitive array with nil dictionary")
		XCTAssertNil(testModel.optionalPrimitiveArray, "Guard statement failed for optional Primitive array with nil dictionary")
	}
	
	func testNilSerializables() {
		XCTAssertEqual(testModel.name.id, SimpleModel().id, "Guard statement failed for Serializable with nil Dictionary")
		XCTAssertNotNil(testModel.names, "Guard statement failed for Serializable array with nil Dictionary")
		XCTAssertEqual(testModel.names.count, 0, "Guard statement failed for Serializable array with nil Dictionary")
		XCTAssertNil(testModel.optionalName, "Guard statement failed for optional Serializable with nil Dictionary")
		XCTAssertNil(testModel.optionalNames, "Guard statement failed for optional Serializable array with nil Dictionary")
		
	}
	
	func testNilEnums() {
		XCTAssertEqual(testModel.someEnum.rawValue, 0, "Guard statement failed for Enum with nil dictionary")
		XCTAssertNotNil(testModel.someEnumArray, "Guard statement failed for Enum array with nil dictionary")
		XCTAssertEqual(testModel.someEnumArray.count, 0, "Guard statement failed for Enum array with nil dictionary")
		XCTAssertNil(testModel.optionalEnum, "Guard statement failed for optional Enum with nil dictionary")
		XCTAssertNil(testModel.optionalEnumArray, "Guard statement failed for optional Enum array with nil dictionary")
	}
	
	func testNilStringInitializables() {
		XCTAssertEqual(testModel.url, URL(string: "http://www.google.com"), "Guard statement failed for StringInitializable with nil dictionary")
		XCTAssertNil(testModel.optionalUrl, "Guard statement failed for optional StringInitializable with nil dictionary")
	}
	
}

