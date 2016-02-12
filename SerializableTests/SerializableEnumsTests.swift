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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStringEnumParsing() {
        XCTAssertEqual(testModel.stringEnum, StringEnum.Value1, "Integer parsing test failed!")
        XCTAssertEqual(testModel.optionalStringEnum, StringEnum.DifferentValue, "Optional integer parsing test failed!")
        XCTAssertEqual(testModel.optionalStringEnumWithDefaultValue, StringEnum.Value1, "Optional integer with default value parsing test failed!")
        XCTAssertEqual(testModel.nonExistentStringEnum, nil, "Optional integer with default value parsing test failed!")
    }

    func testDoubleEnumParsing() {
        XCTAssertEqual(testModel.doubleEnum, DoubleEnum.Value1, "Double parsing test failed!")
        XCTAssertEqual(testModel.optionalDoubleEnum, DoubleEnum.NoneValue, "Optional double parsing test failed!")
        XCTAssertEqual(testModel.optionalDoubleEnumWithDefaultValue, .DifferentValue, "Optional double with default value parsing test failed!")
        XCTAssertEqual(testModel.nonExistentDoubleEnum, nil, "Optional integer with default value parsing test failed!")
    }
}
