//
//  CashierExtensionTests.swift
//  Serializable
//
//  Created by Chris on 14/05/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Cashier
import Serializable

class CashierExtensionTests: XCTestCase {
    
    var simpleModel: SimpleModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        do {
            if let path = NSBundle(forClass: self.dynamicType).pathForResource("SimpleModel", ofType: "json"), data = NSData(contentsOfFile: path) {
                let bridgedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
                simpleModel = SimpleModel(dictionary: bridgedDictionary)
            }
        } catch {
            XCTAssert(false, "Failed to prepare bridged dictionary.")
            return
        }
    } 
    
    func testSerializableCache() {
        
        Cashier.defaultCache().setSerializable(simpleModel, forKey: "SimpleModel")
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("SimpleModel")
        
        XCTAssertNotNil(loadedModel, "Failed to load model from cache")
        XCTAssertEqual(simpleModel.id, loadedModel!.id, "Failed to load correct model from cache")
    }
    
    func testSerializableNilCache() {
        
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("NilSimpleModel")
        XCTAssertNil(loadedModel, "Failed to handle nil from cache")
        
    }
    
    func testSerializableNilArrayCache() {
        
        let loadedModel: [SimpleModel]? = Cashier.defaultCache().serializableForKey("NilSimpleModel")
        XCTAssertNil(loadedModel, "Failed to handle nil from cache")
        
    }
    
    func testSerializableArrayCache() {
        
        Cashier.defaultCache().setSerializable([simpleModel], forKey: "SimpleModel")
        let loadedModel: [SimpleModel]? = Cashier.defaultCache().serializableForKey("SimpleModel")
        
        XCTAssertNotNil(loadedModel, "Failed to load array model from cache")
        XCTAssertEqual(simpleModel.id, loadedModel![0].id, "Failed to load correct array model from cache")
    }
    
    func testClearSerializableCache() {
        Cashier.defaultCache().setSerializable(simpleModel, forKey: "SimpleModel")
        Cashier.defaultCache().clearAllData(purgeMemoryCaches: true)
        
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("SimpleModel")
        XCTAssertNil(loadedModel, "Failed to clear serializables from cache")
        let loadedArrayModel: [SimpleModel]? = Cashier.defaultCache().serializableForKey("SimpleModel")
        XCTAssertNil(loadedArrayModel, "Failed to clear serializables from cache")
    }
    
    func testDeleteSerializableCache() {
        Cashier.defaultCache().setSerializable(simpleModel, forKey: "SimpleModelDelete")
        Cashier.defaultCache().deleteSerializableForKey("SimpleModelDelete")
        
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("SimpleModelDelete")
        XCTAssertNil(loadedModel, "Failed to delete model from cache")
    }

#if TEST_MEMORY_WARNING
    func testLoadIgnoringMemCaches() {
        let box = BridgingBox(simpleModel)
        Cashier.defaultCache().setObject(box, forKey: "ManualBox")
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationDidReceiveMemoryWarningNotification, object: nil) // clear the Cashier mem cache
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("ManualBox")
        
        XCTAssertNotNil(loadedModel, "Failed to load model direct from cache")
        XCTAssertEqual(simpleModel.id, loadedModel!.id, "Failed to load correct model direct from cache")
        
    }
#endif

    func testArrayLoadIgnoringMemCaches() {
        let box = BridgingBox(simpleModel)
        Cashier.defaultCache().setObject([box], forKey: "ManualBox")
        
        let loadedModel: [SimpleModel]? = Cashier.defaultCache().serializableForKey("ManualBox")
        
        XCTAssertNotNil(loadedModel, "Failed to load array model direct from cache")
        XCTAssertEqual(simpleModel.id, loadedModel![0].id, "Failed to load correct array model direct from cache")
        
    }
    
    func testInvalidObjectInBridgingBox() {
        Cashier.defaultCache().setSerializable(simpleModel, forKey: "SimpleModel")
        Cashier.defaultCache().deleteObjectForKey("SimpleModel")
        let loadedModel: SimpleModel? = Cashier.defaultCache().serializableForKey("SimpleModel")
        
        XCTAssertNil(loadedModel, "Failed to return nil model from cache")        
    }
    
    func testInvalidArrayObjectInBridgingBox() {
        Cashier.defaultCache().setSerializable([simpleModel], forKey: "SimpleModel")
        Cashier.defaultCache().deleteObjectForKey("SimpleModel")
        let loadedModel: [SimpleModel]? = Cashier.defaultCache().serializableForKey("SimpleModel")
        
        XCTAssertNil(loadedModel, "Failed to return nil model from cache")
    }
}
