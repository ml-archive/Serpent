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
            if let path = Bundle(for: type(of: self)).path(forResource: "CustomOperatorsTest", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                bridgedDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
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
        XCTAssertNotNil(testModel.someDictionary, "Dictionary parsing with custom operator failed.")
    }

    func testCustomOperatorsEncode() {
        let rep = testModel.encodableRepresentation() as! NSDictionary
		let subArray = testModel.someArray

        XCTAssertEqual(rep.value(forKey: "string") as? String, "success", "String encode with custom operator failed.")
        XCTAssertEqual(rep.value(forKey: "second_string") as? String, "haha", "String encode with custom operator failed.")
        XCTAssertNil(rep.value(forKey: "nil_string"), "Nil string encode with custom operator failed.")
		
		if let type = rep.value(forKey: "some_enum") as? Int {
			XCTAssertEqual(Type(rawValue: type), .second, "Enum encode with custom operator failed.")
		}
		else {
			XCTFail("Enum encode with custom operator failed.")
		}
		XCTAssertEqual(CustomOperatorsTestNestedModel.array(rep.value(forKey: "some_array") as AnyObject?), subArray, "Array encode with custom operator failed.")
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
		XCTAssertEqual(testModel.someUrl, URL(string: "http://www.google.com"), "StringInitializable parsing failed in custom operator")
	}

    func testCustomOperatorDictionaryParsing() {
        XCTAssertEqual(testModel.someDictionary?["test"] as? String, "value", "Dictionary doesn't contain string value for key.")
        XCTAssertEqual(testModel.someDictionary?["integer"] as? Int, 1, "Dictionary doesn't contain integer value for key.")
        XCTAssertEqual(testModel.someDictionary?["float"] as? Double, 1.023, "Dictionary doesn't contain float value for key.")
    }
	
}
 
