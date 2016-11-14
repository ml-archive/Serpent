//
//  NameInfo.swift
//  SerializableExample
//
//  Created by Dominik Hádl on 17/04/16.
//  Copyright © 2016 Nodes ApS. All rights reserved.
//

import Serializable

struct NameInfo {
    var title = ""
    var first = ""
    var last  = ""
}

extension NameInfo: Serializable {
    init(dictionary: NSDictionary?) {
        title <== (self, dictionary, "title")
        first <== (self, dictionary, "first")
        last  <== (self, dictionary, "last")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "title") <== title
        (dict, "first") <== first
        (dict, "last")  <== last
        return dict
    }
}

extension NameInfo {
    var nameString: String {
        return "\(first.capitalizedString) \(last.capitalizedString)"
    }
}