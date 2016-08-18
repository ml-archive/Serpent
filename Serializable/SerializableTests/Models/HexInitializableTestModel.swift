//
//  HexInitializableTest.swift
//  Serializable
//
//  Created by Chris Combs on 10/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable
#if os(OSX)
	import Cocoa
	typealias Color = NSColor
#else
	import UIKit
	typealias Color = UIColor
#endif

struct HexInitializableTestModel {
	var shortColor = Color.red
	var fullColor: Color?
	var badColor: Color?
	var notColor: Color?
    var invalidHexColor: Color?
}

extension HexInitializableTestModel: Serializable {
    init(dictionary: NSDictionary?) {
        shortColor      <== (self, dictionary, "short_color")
        fullColor       <== (self, dictionary, "full_color")
        badColor        <== (self, dictionary, "bad_color")
        notColor        <== (self, dictionary, "not_color")
        invalidHexColor <== (self, dictionary, "invalid_hex_color")
    }
    
    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "short_color")       <== shortColor
        (dict, "full_color")        <== fullColor
        (dict, "bad_color")         <== badColor
        (dict, "not_color")         <== notColor
        (dict, "invalid_hex_color") <== invalidHexColor
        return dict
    }
}

struct HexInitializableTestNilModel {
	var someColor = Color.red
}

extension HexInitializableTestNilModel: Serializable {
	init(dictionary: NSDictionary?) {
		someColor <== (self, dictionary, "some_color")
	}
	
	func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "some_color") <== someColor
		return dict
	}
}
