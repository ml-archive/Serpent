//
//  SerializableEntityTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct SerializableEntityTestModel {
	var id = 0
	var simple: SimpleModel?
	var simples: [SimpleModel]?
	var strings: [String] = []
	var ints: [Int] = []
	var stringInts: [SimpleModel] = []
	var stringDicts: [SimpleModel] = []
}

extension SerializableEntityTestModel:Serializable {
	init(dictionary: NSDictionary?) {
		id <== (self, dictionary, "id")
		simple <== (self, dictionary, "simple")
		simples <== (self, dictionary, "simples")
		strings <== (self, dictionary, "strings")
		ints <== (self, dictionary, "ints")
		stringInts <== (self, dictionary, "stringInts")
		stringDicts <== (self, dictionary, "stringDicts")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id") <== id
		(dict, "simple") <== simple
		(dict, "simples") <== simples
		(dict, "strings") <== strings
		(dict, "ints") <== ints
		(dict, "stringInts") <== stringInts
		(dict, "stringDicts") <== stringDicts
		return dict
	}
}
