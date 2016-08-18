//
//  StringInitializableTestModel.swift
//  Serializable
//
//  Created by Chris Combs on 17/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct StringInitializableTestModel {
	var someUrl: URL?
	var someDate: Date?
    var someEmptyDate: Date?
    var someEmptyURL: URL? //<- some_empty_url
    var someBadDate: Date?
}

extension StringInitializableTestModel: Serializable {
    init(dictionary: NSDictionary?) {
        someUrl       <== (self, dictionary, "some_url")
        someDate      <== (self, dictionary, "some_date")
        someEmptyDate <== (self, dictionary, "some_empty_date")
        someEmptyURL  <== (self, dictionary, "some_empty_url")
        someBadDate   <== (self, dictionary, "some_bad_date")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "some_url")        <== someUrl
        (dict, "some_date")       <== someDate
        (dict, "some_empty_date") <== someEmptyDate
        (dict, "some_empty_url")  <== someEmptyURL
        (dict, "some_bad_date")   <== someBadDate
        return dict
    }
}
