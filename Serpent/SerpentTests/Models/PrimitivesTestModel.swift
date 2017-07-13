//
//  PrimitivesTestModel.swift
//  NOCore
//
//  Created by Dominik Hádl on 17/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serpent

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

extension PrimitivesTestModel: Serializable {
    init(dictionary: NSDictionary?) {
        integer                                 <== (self, dictionary, "integer")
        optionalInteger                         <== (self, dictionary, "optional_integer")
        optionalIntegerWithDefaultValue         <== (self, dictionary, "optional_integer_with_default_value")
        negativeInteger                         <== (self, dictionary, "negative_integer")
        optionalNegativeInteger                 <== (self, dictionary, "optional_negative_integer")
        optionalNegativeIntegerWithDefaultValue <== (self, dictionary, "optional_negative_integer_with_default_value")
        double                                  <== (self, dictionary, "double")
        optionalDouble                          <== (self, dictionary, "optional_double")
        optionalDoubleWithDefaultValue          <== (self, dictionary, "optional_double_with_default_value")
        float                                   <== (self, dictionary, "float")
        optionalFloat                           <== (self, dictionary, "optional_float")
        optionalFloatWithDefaultValue           <== (self, dictionary, "optional_float_with_default_value")
        bool                                    <== (self, dictionary, "bool")
        optionalBool                            <== (self, dictionary, "optional_bool")
        optionalBoolWithDefaultValue            <== (self, dictionary, "optional_bool_with_default_value")
        char                                    <== (self, dictionary, "char")
        optionalChar                            <== (self, dictionary, "optional_char")
        optionalCharWithDefaultValue            <== (self, dictionary, "optional_char_with_default_value")
        string                                  <== (self, dictionary, "string")
        optionalString                          <== (self, dictionary, "optional_string")
        optionalStringWithDefaultValue          <== (self, dictionary, "optional_string_with_default_value")
        intString                               <== (self, dictionary, "int_string")
        doubleString                            <== (self, dictionary, "double_string")
        boolString                              <== (self, dictionary, "bool_string")
        boolIntString                           <== (self, dictionary, "bool_int_string")
        stringDouble                            <== (self, dictionary, "string_double")
        stringBool                              <== (self, dictionary, "string_bool")
    }
    
    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "integer")                                      <== integer
        (dict, "optional_integer")                             <== optionalInteger
        (dict, "optional_integer_with_default_value")          <== optionalIntegerWithDefaultValue
        (dict, "negative_integer")                             <== negativeInteger
        (dict, "optional_negative_integer")                    <== optionalNegativeInteger
        (dict, "optional_negative_integer_with_default_value") <== optionalNegativeIntegerWithDefaultValue
        (dict, "double")                                       <== double
        (dict, "optional_double")                              <== optionalDouble
        (dict, "optional_double_with_default_value")           <== optionalDoubleWithDefaultValue
        (dict, "float")                                        <== float
        (dict, "optional_float")                               <== optionalFloat
        (dict, "optional_float_with_default_value")            <== optionalFloatWithDefaultValue
        (dict, "bool")                                         <== bool
        (dict, "optional_bool")                                <== optionalBool
        (dict, "optional_bool_with_default_value")             <== optionalBoolWithDefaultValue
        (dict, "char")                                         <== char
        (dict, "optional_char")                                <== optionalChar
        (dict, "optional_char_with_default_value")             <== optionalCharWithDefaultValue
        (dict, "string")                                       <== string
        (dict, "optional_string")                              <== optionalString
        (dict, "optional_string_with_default_value")           <== optionalStringWithDefaultValue
        (dict, "int_string")                                   <== intString
        (dict, "double_string")                                <== doubleString
        (dict, "bool_string")                                  <== boolString
        (dict, "bool_int_string")                              <== boolIntString
        (dict, "string_double")                                <== stringDouble
        (dict, "string_bool")                                  <== stringBool
        return dict
    }
}
