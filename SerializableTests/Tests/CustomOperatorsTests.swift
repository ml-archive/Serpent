//
//  CustomOperatorsTests.swift
//  NOCore
//
//  Created by Dominik Hádl on 04/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class CustomOperatorsTests: XCTestCase {

    var bridgedDictionary: NSDictionary!
    var testModel: CustomOperatorsTestModel!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        do {
            if let path = NSBundle(forClass: self.dynamicType).pathForResource("CustomOperatorsTest", ofType: "json"), data = NSData(contentsOfFile: path) {
                bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
                testModel = CustomOperatorsTestModel(dictionary: bridgedDictionary)
            }
        } catch {
            XCTAssert(false, "Failed to prepare bridged dictionary.")
            return
        }
    }

    func testCustomOperatorsDecode() {
        XCTAssertEqual(testModel.string, "success", "String parsing with custom operator failed.")
        XCTAssertEqual(testModel.secondString, "haha", "String parsing with custom operator failed.")
        XCTAssertNil(testModel.nilString, "Nil string parsing with custom operator failed.")
    }

    func testCustomOperatorsEncode() {
        let rep = testModel.encodableRepresentation() as! NSDictionary
		let subArray = testModel.someArray

        XCTAssertEqual(rep.valueForKey("string") as? String, "success", "String encode with custom operator failed.")
        XCTAssertEqual(rep.valueForKey("second_string") as? String, "haha", "String encode with custom operator failed.")
        XCTAssertNil(rep.valueForKey("nil_string"), "Nil string encode with custom operator failed.")
		
		if let type = rep.valueForKey("some_enum") as? Int {
			XCTAssertEqual(Type(rawValue: type), .Second, "Enum encode with custom operator failed.")
		}
		else {
			XCTFail("Enum encode with custom operator failed.")
		}
		XCTAssertEqual(CustomOperatorsTestNestedModel.array(rep.valueForKey("some_array")), subArray, "Array encode with custom operator failed.")
    }

    func testCustomOperatorNestedSerializable() {

        XCTAssertNotNil(testModel.otherSerializable, "Parsing a nested optional serializable failed.")

        XCTAssertEqual(testModel.otherSerializable?.optionalInteger, 2, "Optional integer parsing with custom operator in nested optional serializable failed.")
        XCTAssertEqual(testModel.otherSerializable?.optionalStringWithDefaultValue, "optional default success", "String (optional, w/ default val) parsing in nested optional serializable with custom operator failed.")
        XCTAssertNil(testModel.otherSerializable?.optionalDouble, "Optional double in nested optional serializable expected to be nil.")
		
		XCTAssertNotNil(testModel.someSerializable, "Parsing a nested serializable failed.")
		
		XCTAssertEqual(testModel.someSerializable.optionalInteger, 2, "Optional integer parsing with custom operator in nested serializable failed.")
		XCTAssertEqual(testModel.someSerializable.optionalStringWithDefaultValue, "optional default success", "String (optional, w/ default val) parsing in nested serializable with custom operator failed.")
		XCTAssertNil(testModel.someSerializable.optionalDouble, "Optional double in nested serializable expected to be nil.")
    }
	
	func testCustomOperatorStringInitializable() {
		XCTAssertEqual(testModel.someUrl, NSURL(string: "http://www.google.com"), "StringInitializable parsing failed in custom operator")
	}
	
	func testCustomOperatorHexInitializable() {
		let color = UIColor(red: CGFloat(85) / 255.0, green: CGFloat(170) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0)
		XCTAssertEqual(testModel.someColor, color, "HexInitializable parsing failed in custom operator")
	}
}
