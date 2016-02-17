//
//  DecodableTests.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class DecodableTests: XCTestCase {
	
	var bridgedDictionary: NSDictionary!
	var testModels: [DecodableModel]!
	var testNonArrayModels: [DecodableModel]!
	
    override func setUp() {
        super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("DecodableTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
				testModels = DecodableModel.array(bridgedDictionary["models"])
				testNonArrayModels = DecodableModel.array(bridgedDictionary["model"])
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}
    }
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testArray() {
		if testModels.count == 0 {
			XCTFail("Failed to parse array model.")
			return
		}
		XCTAssertEqual(testModels.count, 4, "Did not create correct number of models in array")
		XCTAssertEqual(testModels[0].id, 1, "First entity model parsing failed")
		XCTAssertEqual(testModels[1].id, 2, "Second entity model parsing failed")
    }
	
	func testNonArray() {
		XCTAssertNotNil(testNonArrayModels, "Create array from non-array JSON failed")
		XCTAssertEqual(testNonArrayModels.count, 0, "Create *empty* array from non-array JSON failed")
	}
}
