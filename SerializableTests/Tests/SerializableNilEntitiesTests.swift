//
//  SerializableNilEntitiesTests.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import XCTest
import Serializable

class SerializableNilEntitiesTests: XCTestCase {
	var testModel: NilModel!
	
	override func setUp() {
		super.setUp()
		
		testModel = NilModel(dictionary: nil)
	}
	
	override func tearDown() {
		super.tearDown()
	}

	func testNilDictionary() {
		XCTAssertNil(testModel.id, "Guard statement failed for primitive with nil Dictionary")
		XCTAssertNil(testModel.name, "Guard statement failed for Serializable with nil Dictionary")
		XCTAssertNotNil(testModel.names, "Guard statement failed for Serializable array with nil Dictionary")
		XCTAssertEqual(testModel.names?.count, 0, "Guard statement failed for Serializable array with nil Dictionary")
	}
}

struct NilModel {
	var id: Int?
	var name: SimpleModel?
	var names: [SimpleModel]?
}
extension NilModel:Serializable {
	init(dictionary: NSDictionary?) {
		id    <== (self, dictionary, key: "id")
		name  <== (self, dictionary, key: "name")
		names <== (self, dictionary, key: "names")
	}
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")    <== id
		(dict ,"name")  <== name
		(dict ,"names") <== names
		return dict
	}
}