//
//  SerializablePerformanceTest.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class SerializablePerformanceTest: XCTestCase {

	var largeData: NSData!
	var smallData: NSData!
	
	var jsonDict: NSDictionary!
	var smallJsonDict: NSDictionary!

	
    override func setUp() {
        super.setUp()
		if let path = Bundle(for: type(of: self)).path(forResource: "PerformanceTest", ofType: "json"), let data = NSData(contentsOfFile: path) {
			largeData = data
		}
		if let path = Bundle(for: type(of: self)).path(forResource: "PerformanceSmallTest", ofType: "json"), let data = NSData(contentsOfFile: path) {
			smallData = data
		}
    }
	

    func testBigPerformance() {
		self.measure { () -> Void in
			do {
				self.jsonDict = try JSONSerialization.jsonObject(with: self.largeData as Data, options: .allowFragments) as? NSDictionary
				let _ = PerformanceTestModel.array(self.jsonDict.object(forKey: "data"))
			}
			catch {
				print(error)
			}
		}
    }

	func testSmallPerformance() {
		self.measure {
			do {
				self.smallJsonDict = try JSONSerialization.jsonObject(with: self.smallData as Data, options: .allowFragments) as? NSDictionary
				let _ = PerformanceTestSmallModel.array(self.smallJsonDict.object(forKey: "data"))
			}
			catch {
				print(error)
			}
		}
	}

	}

