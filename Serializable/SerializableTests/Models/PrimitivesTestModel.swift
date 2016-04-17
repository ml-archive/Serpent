//
//  PrimitivesTestModel.swift
//  NOCore
//
//  Created by Dominik Hádl on 17/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

struct PrimitivesTestModel {
    var integer: Int = 0
    var optionalInteger: Int?
    var optionalIntegerWithDefaultValue: Int? = 0

    var negativeInteger: Int = -1
    var optionalNegativeInteger: Int?
    var optionalNegativeIntegerWithDefaultValue: Int? = -1

    var double: Double = 0.0
    var optionalDouble: Double?
    var optionalDoubleWithDefaultValue: Double? = 0.0

    var float: Float = 0.0
    var optionalFloat: Float?
    var optionalFloatWithDefaultValue: Float? = 0.0

    var bool: Bool = false
    var optionalBool: Bool?
    var optionalBoolWithDefaultValue: Bool? = false

    var char: Character = "A"
    var optionalChar: Character?
    var optionalCharWithDefaultValue: Character? = "A"

    var string: String = ""
    var optionalString: String?
    var optionalStringWithDefaultValue: String? = ""
	
	var intString: Int = 0
	var doubleString: Double = 0.0
	var boolString: Bool = false
	var boolIntString: Bool = false
	
	var stringDouble: String = ""
	var stringBool: String = ""
}

extension PrimitivesTestModel:Serializable {
    init(dictionary: NSDictionary?) {
        integer                                 = self.mapped(dictionary, key: "integer") ?? integer
        optionalInteger                         = self.mapped(dictionary, key: "optional_integer")
        optionalIntegerWithDefaultValue         = self.mapped(dictionary, key: "optional_integer_with_default_value")
        negativeInteger                         = self.mapped(dictionary, key: "negative_integer") ?? negativeInteger
        optionalNegativeInteger                 = self.mapped(dictionary, key: "optional_negative_integer")
        optionalNegativeIntegerWithDefaultValue = self.mapped(dictionary, key: "optional_negative_integer_with_default_value")
        double                                  = self.mapped(dictionary, key: "double") ?? double
        optionalDouble                          = self.mapped(dictionary, key: "optional_double")
        optionalDoubleWithDefaultValue          = self.mapped(dictionary, key: "optional_double_with_default_value")
        float                                   = self.mapped(dictionary, key: "float") ?? float
        optionalFloat                           = self.mapped(dictionary, key: "optional_float")
        optionalFloatWithDefaultValue           = self.mapped(dictionary, key: "optional_float_with_default_value")
        bool                                    = self.mapped(dictionary, key: "bool") ?? bool
        optionalBool                            = self.mapped(dictionary, key: "optional_bool")
        optionalBoolWithDefaultValue            = self.mapped(dictionary, key: "optional_bool_with_default_value")
        char                                    = self.mapped(dictionary, key: "char") ?? char
        optionalChar                            = self.mapped(dictionary, key: "optional_char")
        optionalCharWithDefaultValue            = self.mapped(dictionary, key: "optional_char_with_default_value")
        string                                  = self.mapped(dictionary, key: "string") ?? string
        optionalString                          = self.mapped(dictionary, key: "optional_string")
        optionalStringWithDefaultValue          = self.mapped(dictionary, key: "optional_string_with_default_value")
		intString								= self.mapped(dictionary, key: "intString") ?? intString
		doubleString							= self.mapped(dictionary, key: "doubleString") ?? doubleString
		boolString								= self.mapped(dictionary, key: "boolString") ?? boolString
		boolIntString							= self.mapped(dictionary, key: "boolIntString") ?? boolIntString
		stringDouble							= self.mapped(dictionary, key: "stringDouble") ?? stringDouble
		stringBool								= self.mapped(dictionary, key: "stringBool") ?? stringBool
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        dict["integer"]                                      = integer
        dict["optional_integer"]                             = optionalInteger
        dict["optional_integer_with_default_value"]          = optionalIntegerWithDefaultValue
        dict["negative_integer"]                             = negativeInteger
        dict["optional_negative_integer"]                    = optionalNegativeInteger
        dict["optional_negative_integer_with_default_value"] = optionalNegativeIntegerWithDefaultValue
        dict["double"]                                       = double
        dict["optional_double"]                              = optionalDouble
        dict["optional_double_with_default_value"]           = optionalDoubleWithDefaultValue
        dict["float"]                                        = float
        dict["optional_float"]                               = optionalFloat
        dict["optional_float_with_default_value"]            = optionalFloatWithDefaultValue
        dict["bool"]                                         = bool
        dict["optional_bool"]                                = optionalBool
        dict["optional_bool_with_default_value"]             = optionalBoolWithDefaultValue
        dict["char"]                                         = "\(char)"
        dict["optional_char"]                                = optionalChar != nil ? "\(optionalChar!)" : "\(optionalChar)"
        dict["optional_char_with_default_value"]             = optionalCharWithDefaultValue != nil ? "\(optionalCharWithDefaultValue!)" : "\(optionalCharWithDefaultValue)"
        dict["string"]                                       = string
        dict["optional_string"]                              = optionalString
        dict["optional_string_with_default_value"]           = optionalStringWithDefaultValue
		dict["intString"]									 = intString
		dict["doubleString"]								 = doubleString
		dict["boolString"]									 = boolString
		dict["boolIntString"]								 = boolIntString
		dict["stringBool"]									 = stringBool
        return dict
    }
}
