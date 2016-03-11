//
//  HexInitalizableTests.swift
//  Serializable
//
//  Created by Chris Combs on 10/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable

class HexInitalizableTests: XCTestCase {

	var testModel: HexInitializableTestModel!
	
	override func setUp() {
		super.setUp()
		do {
			if let path = NSBundle(forClass: self.dynamicType).pathForResource("HexInitializableTest", ofType: "json"), data = NSData(contentsOfFile: path) {
				let bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
				testModel = HexInitializableTestModel(dictionary: bridgedDictionary)
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}
	}
	
	func testHexInitializableUIColor() {
		let color = UIColor(red: CGFloat(85) / 255.0, green: CGFloat(170) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0)
		XCTAssertEqual(testModel.shortColor, color, "Error parsing short form color in HexInitializable")
		XCTAssertEqual(testModel.fullColor, color, "Error parsing long form color in HexInitializable")
		XCTAssertNil(testModel.badColor, "Error returning nil for malformed color hex")
		XCTAssertNil(testModel.notColor, "Error returning nil for non hex value")
        XCTAssertNil(testModel.invalidHexColor, "Error returning nil for invalid hex value")
	}

}
