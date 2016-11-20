//
//  Identification.swift
//  SerpentExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serpent

struct Identification {
    var name  = ""
    var value = ""
}

extension Identification: Serializable {
    init(dictionary: NSDictionary?) {
        name  <== (self, dictionary, "name")
        value <== (self, dictionary, "value")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "name")  <== name
        (dict, "value") <== value
        return dict
    }
}
