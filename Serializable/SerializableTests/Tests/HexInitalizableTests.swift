//
//  HexInitalizableTests.swift
//  Serializable
//
//  Created by Chris Combs on 10/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable
#if os(OSX)
	import Cocoa
	typealias HexColor = NSColor
#else
	import UIKit
	typealias HexColor = UIColor
#endif

class HexInitalizableTests: XCTestCase {

	var testModel: HexInitializableTestModel!
	
	override func setUp() {
		super.setUp()
		do {
			if let path = Bundle(for: type(of: self)).path(forResource: "HexInitializableTest", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
				let bridgedDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
				testModel = HexInitializableTestModel(dictionary: bridgedDictionary)
			}
		} catch {
			XCTFail("Failed to prepare bridged dictionary.")
			return
		}
	}
	
	func testHexInitializableUIColor() {
		let color = HexColor(red: CGFloat(85) / 255.0, green: CGFloat(170) / 255.0, blue: CGFloat(204) / 255.0, alpha: 1.0)
		XCTAssertEqual(testModel.shortColor, color, "Error parsing short form color in HexInitializable")
		XCTAssertEqual(testModel.fullColor, color, "Error parsing long form color in HexInitializable")
		XCTAssertNil(testModel.badColor, "Error returning nil for malformed color hex")
		XCTAssertNil(testModel.notColor, "Error returning nil for non hex value")
        XCTAssertNil(testModel.invalidHexColor, "Error returning nil for invalid hex value")
	}
	
	func testHexInitializableNilDictionary() {
		let nilModel = HexInitializableTestNilModel(dictionary: nil)
		XCTAssertEqual(nilModel.someColor, HexColor.red, "Failed to parse nil dictionary into HexInitializable model")
	}

}
