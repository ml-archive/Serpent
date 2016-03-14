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
		XCTAssertEqual(testModel.url, NSURL(string: "http://www.google.com"), "Guard statement failed for StringInitializable with nil dictionary")
		XCTAssertNil(testModel.optionalUrl, "Guard statement failed for optional StringInitializable with nil dictionary")
	}
	
	func testNilHexInitializable() {
		XCTAssertNil(testModel.someColor, "Guard statement failed for optional HexInitializable with nil dictionary")
		XCTAssertEqual(testModel.someDefaultColor, UIColor.redColor(), "Default value failed for optional HexInitializable with nil dictionary")
	}
}

public struct NilModel {
	
	public enum Type: Int {
		case First = 0
		case Second = 1
	}
	
	var id: Int = 0
	var name = SimpleModel()
	var names = [SimpleModel]()
	var url = NSURL(string: "http://www.google.com")!
	var someEnum: Type = .First
	var someEnumArray: [Type] = []
	var somePrimitiveArray: [String] = []
	var someColor: UIColor?
	var someDefaultColor: UIColor = UIColor.redColor()
	
	var optionalId: Int?
	var optionalName: SimpleModel?
	var optionalNames: [SimpleModel]?
	var optionalUrl: NSURL?
	var optionalEnum: Type?
	var optionalEnumArray: [Type]?
	var optionalPrimitiveArray: [String]?
}
extension NilModel: Serializable {
	public init(dictionary: NSDictionary?) {
		id                     <== (self, dictionary, "id")
		name                   <== (self, dictionary, "name")
		names                  <== (self, dictionary, "names")
		url                    <== (self, dictionary, "url")
		someEnum               <== (self, dictionary, "some_enum")
		someEnumArray          <== (self, dictionary, "some_enum_array")
		somePrimitiveArray     <== (self, dictionary, "some_primitive_array")
		someColor              <== (self, dictionary, "some_color")
		someDefaultColor       <== (self, dictionary, "some_default_color")
		optionalId             <== (self, dictionary, "optional_id")
		optionalName           <== (self, dictionary, "optional_name")
		optionalNames          <== (self, dictionary, "optional_names")
		optionalUrl            <== (self, dictionary, "optional_url")
		optionalEnum           <== (self, dictionary, "optional_enum")
		optionalEnumArray      <== (self, dictionary, "optional_enum_array")
		optionalPrimitiveArray <== (self, dictionary, "optional_primitive_array")
	}
	
	public func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")                       <== id
		(dict, "name")                     <== name
		(dict, "names")                    <== names
		(dict, "url")                      <== url
		(dict, "some_enum")                <== someEnum
		(dict, "some_enum_array")          <== someEnumArray
		(dict, "some_primitive_array")     <== somePrimitiveArray
		(dict, "some_color")               <== someColor
		(dict, "some_default_color")       <== someDefaultColor
		(dict, "optional_id")              <== optionalId
		(dict, "optional_name")            <== optionalName
		(dict, "optional_names")           <== optionalNames
		(dict, "optional_url")             <== optionalUrl
		(dict, "optional_enum")            <== optionalEnum
		(dict, "optional_enum_array")      <== optionalEnumArray
		(dict, "optional_primitive_array") <== optionalPrimitiveArray
		return dict
	}
}