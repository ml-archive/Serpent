//
//  PerformanceTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 25/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//


import Serpent


struct PerformanceTestSmallModel {	
	var id = ""
	var name = ""
}

extension PerformanceTestSmallModel: Serializable {
	init(dictionary: NSDictionary?) {
		id   <== (self, dictionary, "id")
		name <== (self, dictionary, "name")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")   <== id
		(dict, "name") <== name
		return dict
	}
}
