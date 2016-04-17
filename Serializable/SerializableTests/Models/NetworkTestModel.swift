//
//  NetworkTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 18/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Serializable

struct NetworkTestModel {
	var origin = ""
	var url: NSURL?
}

extension NetworkTestModel: Serializable {
	init(dictionary: NSDictionary?) {
		origin <== (self, dictionary, "origin")
		url    <== (self, dictionary, "url")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "origin") <== origin
		(dict, "url")    <== url
		return dict
	}
}

struct BadModel {
	var something = ""
}

extension BadModel: Serializable {
	init(dictionary: NSDictionary?) {
		something <== (self, dictionary, "something")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "something") <== something
		return dict
	}
}

