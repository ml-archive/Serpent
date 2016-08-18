//
//  BridgingBoxTests.swift
//  Serializable
//
//  Created by Chris on 14/05/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable

class BridgingBoxTests: XCTestCase {
    
    var simpleModel: SimpleModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        do {
            if let path = Bundle(for: type(of: self)).path(forResource: "SimpleModel", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let bridgedDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                simpleModel = SimpleModel(dictionary: bridgedDictionary)
            }
        } catch {
            XCTAssert(false, "Failed to prepare bridged dictionary.")
            return
        }
    }
    
    func testBridgingBoxValue() {
        let box = BridgingBox(simpleModel)
        let value: SimpleModel? = box.value()
        XCTAssertNotNil(value, "Failed to load value from bridging box")
        XCTAssertEqual(value!.id, simpleModel.id, "Failed to load value from bridging box")
    }

}
