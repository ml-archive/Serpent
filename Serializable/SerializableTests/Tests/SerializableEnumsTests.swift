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

class SerializableEnumsTests: XCTestCase {

    var bridgedDictionary: NSDictionary!
    var testModel: EnumsTestModel!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        do {
            if let path = NSBundle(forClass: self.dynamicType).pathForResource("EnumsTest", ofType: "json"), data = NSData(contentsOfFile: path) {
                bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
                testModel = EnumsTestModel(dictionary: bridgedDictionary)
            }
        } catch {
            XCTAssert(false, "Failed to prepare bridged dictionary.")
            return
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testStringEnumParsing() {
        XCTAssertEqual(testModel.stringEnum, StringEnum.Value1, "String parsing test failed!")
        XCTAssertEqual(testModel.optionalStringEnum, StringEnum.DifferentValue, "Optional String parsing test failed!")
        XCTAssertEqual(testModel.optionalStringEnumWithDefaultValue, StringEnum.Value1, "Optional String with default value parsing test failed!")
        XCTAssertEqual(testModel.nonExistentStringEnum, nil, "Optional String with default value parsing test failed!")
    }
    
    func testStringEnumArrayParsing() {
        XCTAssertEqual(testModel.stringEnumArray, [StringEnum.Value1, StringEnum.DifferentValue], "String enum array test failed!")
        XCTAssertEqual(testModel.optionalStringEnumArray!, [StringEnum.Value1, StringEnum.DifferentValue], "Optional string enum array test failed!")
        XCTAssertEqual(testModel.optionalStringEnumArrayWithDefaultValue!, [StringEnum.Value1, StringEnum.DifferentValue], "Optional string enum array with default value test failed!")
        XCTAssertNil(testModel.nonExistentStringEnumArray, "Optional string enum array with non existent value test failed!")
        XCTAssertNil(testModel.wrongTypeStringEnumArray, "Wrong type string enum array test failed!")
    }

    func testDoubleEnumArrayParsing() {
        XCTAssertEqual(testModel.doubleEnumArray, [DoubleEnum.Value1, DoubleEnum.DifferentValue], "Double enum array test failed!")
        XCTAssertEqual(testModel.optionalDoubleEnumArray!, [DoubleEnum.Value1, DoubleEnum.DifferentValue], "Optional double enum array test failed!")
        XCTAssertEqual(testModel.optionalDoubleEnumArrayWithDefaultValue!, [DoubleEnum.Value1, DoubleEnum.DifferentValue], "Optional double enum array with default value test failed!")
        XCTAssertNil(testModel.nonExistentDoubleEnumArray, "Optional double enum array with non existent value test failed!")
        XCTAssertNil(testModel.wrongTypeDoubleEnumArray,"Wrong type double enum array test failed!")
    }
}
