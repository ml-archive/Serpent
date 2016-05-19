//
//  DecodableModel.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct DecodableModel {
	var id = 0
	var name = ""
	var text = ""
}

extension DecodableModel:Serializable {
	init(dictionary: NSDictionary?) {
		id   <== (self, dictionary, key: "id")
		name <== (self, dictionary, key: "name")
		text <== (self, dictionary, key: "text")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict     = NSMutableDictionary()
		(dict, "id")   <== id
		(dict, "name") <== name
		(dict, "text") <== text
		return dict
	}
}