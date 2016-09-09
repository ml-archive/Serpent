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
	
    let timeoutDuration = 60.0
    
	let manager = SessionManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
 
	
	func testAlamofireExtension() {
		let expectation = self.expectation(description: "Expected network request success")
		let handler:(Alamofire.DataResponse<NetworkTestModel>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break // Fail
				
			}
		}
		manager.request("http://httpbin.org/get", method: .get).responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	
	func testAlamofireExtensionBadJSON() {
		let expectation = self.expectation(description: "Expected bad data from response")
		let handler:(Alamofire.DataResponse<NetworkTestModel>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request("http://httpbin.org/deny", method: .get).responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}

	
	func testAlamofireExtensionBadJSONObject() {
		let expectation = self.expectation(description: "Expected bad object from response")
		let handler:(Alamofire.DataResponse<[NetworkTestModel]>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request("http://httpbin.org/get", method: .get).responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	func testAlamofireExtensionUnexpectedArrayJSON() {
		let expectation = self.expectation(description: "Expected array data to single object from response")
		let handler:(Alamofire.DataResponse<DecodableModel>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/ArrayTest.json", method: .get).responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	func testAlamofireExtensionEmptyJSON() {
		let expectation = self.expectation(description: "Expected empty response")
		let handler:(Alamofire.DataResponse<NetworkTestModel>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}
		manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/Empty.json", method: .get).responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	func testAlamofireArrayUnwrapper() {
		let expectation = self.expectation(description: "Expected unwrapped array response")
		let handler:(Alamofire.DataResponse<[DecodableModel]>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break
			}
		}
		let unwrapper: Parser.Unwrapper = { $0.0["data"] }
		
		manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json",
		                method: .get)
			.responseSerializable(handler, unwrapper: unwrapper)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	
	func testAlamofireArrayNotUnwrapped() {
		let expectation = self.expectation(description: "Expected unwrapped array response")
		let handler:(Alamofire.DataResponse<[DecodableModel]>) -> Void = { result in
			switch result.result {
			case .failure:
				expectation.fulfill()
			default:
				break
			}
		}		
		
		manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json",
		                method: .get)
			.responseSerializable(handler)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
	func testAlamofireWrongTypeUnwrapper() {
		let expectation = self.expectation(description: "Expected unwrapped array response")
		let handler:(Alamofire.DataResponse<DecodableModel>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				break
			}
		}
		let unwrapper: Parser.Unwrapper = { $0.0["data"] }
		
		manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/NestedArrayTest.json",
			method: .get)
			.responseSerializable(handler, unwrapper: unwrapper)
		waitForExpectations(timeout: timeoutDuration, handler: nil)
	}
    
    func testAlamofireExtensionNonSerializable() {
        let expectation = self.expectation(description: "Expected empty response")
        let handler:(Alamofire.DataResponse<NilSerializable>) -> Void = { result in
            switch result.result {
            case .failure:
                expectation.fulfill()
            default:
                break
            }
        }
        manager.request("https://raw.githubusercontent.com/nodes-ios/Serializable/master/Serializable/SerializableTests/TestEndpoint/Empty.json", method: .get).responseSerializable(handler)
        waitForExpectations(timeout: timeoutDuration, handler: nil)
    }
}
