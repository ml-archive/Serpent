//
//  SimpleModel.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct SimpleModel {
	var id = 0
}

extension SimpleModel:Serializable {
	init(dictionary: NSDictionary?) {
		id <== (self, dictionary, key: "id")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id") <== id
		return dict
	}
}