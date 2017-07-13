//
//  EmbeddedPropertyTestModel.swift
//  SerpentTests
//
//  Created by Jakob Mygind Jensen on 03/07/2017.
//  Copyright © 2017 Nodes. All rights reserved.
//

import Foundation
import Serpent

struct EmbeddedPropertyTestModel {
    var name = ""
    var date: Date?                         // <-propertyObject/embeddedDate
    var embeddedName: String?               // <-propertyObject/embeddedName
    var embeddedObject: EmbeddedObjectType? // <-propertyObject/embeddedObject
}

extension EmbeddedPropertyTestModel: Serializable {
    init(dictionary: NSDictionary?) {
        name           <== (self, dictionary, "name")
        date           <== (self, dictionary, "propertyObject/embeddedDate")
        embeddedName   <== (self, dictionary, "propertyObject/embeddedName")
        embeddedObject <== (self, dictionary, "propertyObject/embeddedObject")
    }
    
    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "name")                          <== name
        (dict, "propertyObject/embeddedDate")   <== date
        (dict, "propertyObject/embeddedName")   <== embeddedName
        (dict, "propertyObject/embeddedObject") <== embeddedObject
        return dict
    }
}

extension EmbeddedPropertyTestModel {
    var containsEmbeddedProperties: Bool {
        return true
    }
}

struct EmbeddedObjectType {
    var embeddedProperty: String?
}

extension EmbeddedObjectType: Serializable {
    init(dictionary: NSDictionary?) {
        embeddedProperty <== (self, dictionary, "embeddedProperty")
    }
    
    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "embeddedProperty") <== embeddedProperty
        return dict
    }
}
