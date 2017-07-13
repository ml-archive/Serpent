//
//  EmbeddedPropertyTest.swift
//  SerpentTests
//
//  Created by Jakob Mygind Jensen on 03/07/2017.
//  Copyright © 2017 Nodes. All rights reserved.
//

import XCTest

class EmbeddedPropertyTest: XCTestCase {
    
    var testModel: EmbeddedPropertyTestModel!
    
    override func setUp() {
        super.setUp()
        do {
            Date.customDateFormats = ["yyyy-MM-dd HH:mm:ss"]
            if let path = Bundle(for: type(of: self)).path(forResource: "EmbeddedPropertyTest", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                
                let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                testModel = EmbeddedPropertyTestModel(dictionary: dictionary)
            }
        } catch {
            XCTFail("Failed to prepare dictionary.")
            return
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsing() {
        XCTAssert(testModel.embeddedObject != nil, "EmbeddedObject was not parsed")
        XCTAssert(testModel.date != nil, "Date was not parsed")
        XCTAssert(testModel.embeddedName != nil, "EmbeddedName was not parsed")
        
    }
    
}
