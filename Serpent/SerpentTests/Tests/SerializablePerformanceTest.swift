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
        do {
            self.jsonDict = try JSONSerialization.jsonObject(with: self.largeData as Data, options: .allowFragments) as? NSDictionary
        }
        catch {
            print(error)
        }
    }

    override func tearDown() {
        super.tearDown()
        largeData = nil
        smallData = nil
        jsonDict = nil
        smallJsonDict = nil
    }

    func testBigPerformance() {
        let array = self.jsonDict.object(forKey: "data")
		self.measure { () -> Void in
            let _ = PerformanceTestModel.array(array)
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

