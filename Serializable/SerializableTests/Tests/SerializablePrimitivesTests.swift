//
//  SerializablePrimitivesTests.swift
//  NOCore
//
//  Created by Dominik Hádl on 17/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import XCTest

// TODO: Add tests for explicit Int8, Int16, Int32, Int64 and all UInt variants, Float80 and UnicodeScalar

class SerializablePrimitivesTests: XCTestCase {

    var bridgedDictionary: NSDictionary!
    var testModel: PrimitivesTestModel!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        do {
            if let path = NSBundle(forClass: self.dynamicType).pathForResource("PrimitivesTest", ofType: "json"), data = NSData(contentsOfFile: path) {
                bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
                testModel = PrimitivesTestModel(dictionary: bridgedDictionary)
            }
        } catch {
            XCTAssert(false, "Failed to prepare bridged dictionary.")
            return
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIntegerParsing() {
        XCTAssertEqual(testModel.integer, 1, "Integer parsing test failed!")
        XCTAssertEqual(testModel.optionalInteger, 2, "Optional integer parsing test failed!")
        XCTAssertEqual(testModel.optionalIntegerWithDefaultValue, 3, "Optional integer with default value parsing test failed!")
		XCTAssertEqual(testModel.intString, 1, "Integer parsing from string failed")
    }

    func testNegativeIntegerParsing() {
        XCTAssertEqual(testModel.negativeInteger, -10, "Negative integer parsing test failed!")
        XCTAssertEqual(testModel.optionalNegativeInteger, -20, "Optional negative integer parsing test failed!")
        XCTAssertEqual(testModel.optionalNegativeIntegerWithDefaultValue, -30, "Optional negative integer with default value parsing test failed!")
    }

    func testDoubleParsing() {
        XCTAssertEqual(testModel.double, 123.1234567, "Double parsing test failed!")
        XCTAssertEqual(testModel.optionalDouble, 234.2345678, "Optional double parsing test failed!")
        XCTAssertEqual(testModel.optionalDoubleWithDefaultValue, 345.3456789, "Optional double with default value parsing test failed!")
		XCTAssertEqual(testModel.doubleString, 1.5, "Double parsing from string failed")
    }

    func testFloatParsing() {
        XCTAssertEqual(testModel.float, 1.234, "Float parsing test failed!")
        XCTAssertEqual(testModel.optionalFloat, 2.345, "Optional float parsing test failed!")
        XCTAssertEqual(testModel.optionalFloatWithDefaultValue, 3.456, "Optional float with default value parsing test failed!")
    }

    func testBoolParsing() {
        XCTAssertTrue(testModel.bool, "Bool parsing test failed!")
        XCTAssertTrue(testModel.optionalBool ?? false, "Optional bool parsing test failed!")
        XCTAssertTrue(testModel.optionalBoolWithDefaultValue ?? false, "Optional bool with default value parsing test failed!")
		XCTAssertEqual(testModel.boolString, true, "Bool parsing from string failed")
		XCTAssertEqual(testModel.boolIntString, true, "Bool parsing from integer string failed")
    }

    func testCharParsing() {
        XCTAssertEqual(testModel.char, "S", "Character parsing test failed!")
        XCTAssertEqual(testModel.optionalChar, "O", "Optional character parsing test failed!")
        XCTAssertEqual(testModel.optionalCharWithDefaultValue, "D", "Optional character with default value parsing test failed!")
    }

    func testStringParsing() {
        XCTAssertEqual(testModel.string, "success", "String parsing test failed!")
        XCTAssertEqual(testModel.optionalString, "optional success", "Optional string parsing test failed!")
        XCTAssertEqual(testModel.optionalStringWithDefaultValue, "optional default success", "Optional string with default value parsing test failed!")
		XCTAssertEqual(testModel.stringDouble, "1.5", "String parsing from double failed")
		XCTAssertEqual(testModel.stringBool, "1", "String parsing from bool failed")
    }
}
