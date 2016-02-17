//
//  StringInitializableTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 17/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct StringInitializableTestModel {
	var someUrl: NSURL?
	var someDate: Date?
	var someNSDate: NSDate?
	var someEmptyURL: NSURL?
}

extension StringInitializableTestModel:Serializable {
	init(dictionary: NSDictionary?) {
		someUrl <== (self, dictionary, key: "someUrl")
		someDate <== (self, dictionary, key: "someDate")
		someNSDate <== (self, dictionary, key: "someNSDate")
		someEmptyURL <== (self, dictionary, key: "somesomeEmptyURL")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "someUrl") <== someUrl
		(dict, "someDate") <== someNSDate
		(dict, "someNSDate") <== someNSDate
		(dict, "someEmptyURL") <== someEmptyURL
		return dict
	}
}