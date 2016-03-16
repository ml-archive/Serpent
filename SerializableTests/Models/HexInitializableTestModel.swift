//
//  HexInitializableTest.swift
//  Serializable
//
//  Created by Chris Combs on 10/03/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import UIKit
import Serializable

struct HexInitializableTestModel {
	var shortColor = UIColor.redColor()
	var fullColor: UIColor?
	var badColor: UIColor?
	var notColor: UIColor?
    var invalidHexColor: UIColor?
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