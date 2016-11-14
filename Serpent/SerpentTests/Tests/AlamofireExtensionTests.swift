//
//  AlamofireExtensionTests.swift
//  Serializable
//
//  Created by Chris Combs on 18/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Serpent
import Alamofire

class AlamofireExtensionTests: XCTestCase {
	
    let timeoutDuration = 2.0
    
	let manager = SessionManager()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
	func urlForResource(resource: String) -> URL? {
		if let path = Bundle(for: type(of: self)).path(forResource: resource, ofType: "json") {
			return URL(fileURLWithPath: path)
		}
		return nil
	}
	
	func testAlamofireExtension() {
		let expectation = self.expectation(description: "Expected network request success")
		let handler:(Alamofire.DataResponse<NetworkTestModel>) -> Void = { result in
			switch result.result {
			case .success:
				expectation.fulfill()
			default:
				print(result)
				break // Fail
				
			}
		}
		if let url = urlForResource(resource: "NetworkModel") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		if let url = urlForResource(resource: "NetworkModelBad") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		if let url = urlForResource(resource: "NetworkModel") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		if let url = urlForResource(resource: "ArrayTest") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		if let url = urlForResource(resource: "Empty") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		
		if let url = urlForResource(resource: "NestedArrayTest") {
			manager.request(url, method: .get).responseSerializable(handler, unwrapper: unwrapper)
		}
		
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
		
		if let url = urlForResource(resource: "NestedArrayTest") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
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
		
		if let url = urlForResource(resource: "NestedArrayTest") {
			manager.request(url, method: .get).responseSerializable(handler, unwrapper: unwrapper)
		}
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
		if let url = urlForResource(resource: "Empty") {
			manager.request(url, method: .get).responseSerializable(handler)
		}
        waitForExpectations(timeout: timeoutDuration, handler: nil)
    }
}
