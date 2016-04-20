//
//  Location.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable

struct Location {
    var street   = ""
    var city     = ""
    var state    = ""
    var postcode = 0
}

extension Location: Serializable {
    init(dictionary: NSDictionary?) {
        street   <== (self, dictionary, "street")
        city     <== (self, dictionary, "city")
        state    <== (self, dictionary, "state")
        postcode <== (self, dictionary, "postcode")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "street")   <== street
        (dict, "city")     <== city
        (dict, "state")    <== state
        (dict, "postcode") <== postcode
        return dict
    }
}