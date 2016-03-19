//
//  AlamofireExtensionTests.swift
//  Serializable
//
//  Created by Chris Combs on 18/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serializable
import Alamofire

class AlamofireExtensionTests: XCTestCase {
	
	let manager = Manager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
 
	
	func testAlamofireExtension() {
		let expectation = expectationWithDescription("Expected network request success")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .Success:
				expectation.fulfill()
			default:
				break // Fail
				
			}
		}
		manager.request(.GET, "http://httpbin.org/get").responseSerializable(handler)
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	
	func testAlamofireExtensionBadJSON() {
		let expectation = expectationWithDescription("Expected bad data from response")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .Failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request(.GET, "http://httpbin.org/deny").responseSerializable(handler)
		waitForExpectationsWithTimeout(1, handler: nil)
	}

	
	func testAlamofireExtensionBadJSONObject() {
		let expectation = expectationWithDescription("Expected bad object from response")
		let handler:(Alamofire.Response<[NetworkTestModel], NSError>) -> Void = { result in
			switch result.result {
			case .Failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request(.GET, "http://httpbin.org/get").responseSerializable(handler)
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	func testAlamofireExtensionUnexpectedArrayJSON() {
		let expectation = expectationWithDescription("Expected array data to single object from response")
		let handler:(Alamofire.Response<[DecodableModel], NSError>) -> Void = { result in
			switch result.result {
			case .Failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request(.GET, "https://raw.githubusercontent.com/nodes-ios/Serializable/Alamofire-Additions/SerializableTests/TestEndpoint/ArrayTest.json").responseSerializable(handler)
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	func testAlamofireExtensionEmptyJSON() {
		let expectation = expectationWithDescription("Expected empty response")
		let handler:(Alamofire.Response<NetworkTestModel, NSError>) -> Void = { result in
			switch result.result {
			case .Failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request(.GET, "https://raw.githubusercontent.com/nodes-ios/Serializable/Alamofire-Additions/SerializableTests/TestEndpoint/ArrayTest.json").responseSerializable(handler)
		waitForExpectationsWithTimeout(1, handler: nil)
	}
	
}
