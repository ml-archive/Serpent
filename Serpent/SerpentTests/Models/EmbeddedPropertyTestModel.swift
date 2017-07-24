//
//  EmbeddedPropertyTestModel.swift
//  SerpentTests
//
//  Created by Jakob Mygind Jensen on 03/07/2017.
//  Copyright © 2017 Nodes. All rights reserved.
//

import Foundation
import Serpent
import UIKit

struct EmbeddedPropertyTestModel {
    var name = ""
    var date: Date?                         // <-propertyObject/embeddedDate
    var embeddedName: String?               // <-propertyObject/embeddedName
    var embeddedObject: EmbeddedObjectType? // <-propertyObject/embeddedObject
    var embeddedDouble: Double?             // <-propertyObject/embeddedDouble
    var embeddedColor: UIColor?             // <-propertyObject/embeddedColor
    var embeddedBool: Bool?                 // <-propertyObject/embeddedBool
}

extension EmbeddedPropertyTestModel: Serializable {
    init(dictionary: NSDictionary?) {
        name           <== (self, dictionary, "name")
        date           <== (self, dictionary, "propertyObject/embeddedDate")
        embeddedName   <== (self, dictionary, "propertyObject/embeddedName")
        embeddedObject <== (self, dictionary, "propertyObject/embeddedObject")
        embeddedDouble <== (self, dictionary, "propertyObject/embeddedDouble")
        embeddedColor  <== (self, dictionary, "propertyObject/embeddedColor")
        embeddedBool   <== (self, dictionary, "propertyObject/embeddedBool")
    }
    
    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "name")                          <== name
        (dict, "propertyObject/embeddedDate")   <== date
        (dict, "propertyObject/embeddedName")   <== embeddedName
        (dict, "propertyObject/embeddedObject") <== embeddedObject
        (dict, "propertyObject/embeddedDouble") <== embeddedDouble
        (dict, "propertyObject/embeddedColor")  <== embeddedColor
        (dict, "propertyObject/embeddedBool")   <== embeddedBool
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
