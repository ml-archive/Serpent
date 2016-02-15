//
//  PrimitivesTestModel.swift
//  NOCore
//
//  Created by Dominik Hádl on 17/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serializable

enum StringEnum: String {
    case Value1 = "value1"
    case DifferentValue = "DifferentValue"
    case NoneValue
}

enum DoubleEnum: Double {
    case NoneValue
    case Value1 = 123.456
    case DifferentValue = -9453.5147684
}

struct EnumsTestModel {
    var stringEnum: StringEnum = .NoneValue
    var optionalStringEnum: StringEnum?
    var optionalStringEnumWithDefaultValue: StringEnum? = .NoneValue
    var nonExistentStringEnum: StringEnum?
    var wrongTypeStringEnum: StringEnum?

    var stringEnumArray: [StringEnum] = [StringEnum]()
    var optionalStringEnumArray: [StringEnum]?
    var optionalStringEnumArrayWithDefaultValue: [StringEnum]? = [StringEnum]()
    var nonExistentStringEnumArray: [StringEnum]?
    var wrongTypeStringEnumArray: [StringEnum]?
    
    var doubleEnum: DoubleEnum = .NoneValue
    var optionalDoubleEnum: DoubleEnum?
    var optionalDoubleEnumWithDefaultValue: DoubleEnum? = .NoneValue
    var nonExistentDoubleEnum: DoubleEnum?
    var wrongTypeDoubleEnum: DoubleEnum?
    
    var doubleEnumArray: [DoubleEnum] = [DoubleEnum]()
    var optionalDoubleEnumArray: [DoubleEnum]?
    var optionalDoubleEnumArrayWithDefaultValue: [DoubleEnum]? = [DoubleEnum]()
    var nonExistentDoubleEnumArray: [DoubleEnum]?
    var wrongTypeDoubleEnumArray: [DoubleEnum]?
}

extension EnumsTestModel:Serializable {
    init(dictionary: NSDictionary?) {
        stringEnum							<== (self, dictionary, key: "string_enum")
        optionalStringEnum					<== (self, dictionary, key: "optional_string_enum")
        optionalStringEnumWithDefaultValue	<== (self, dictionary, key: "optional_string_enum_with_default_value")
        nonExistentStringEnum				<== (self, dictionary, key: "non_existent_string_enum")
        wrongTypeStringEnum					<== (self, dictionary, key: "wrong_type_string_enum")
        
        stringEnumArray                         <== (self, dictionary, key: "string_enum_array")
        optionalStringEnumArray                 <== (self, dictionary, key: "optional_string_enum_array")
        optionalStringEnumArrayWithDefaultValue <== (self, dictionary, key: "optional_string_enum_array_with_default_value")
        nonExistentStringEnumArray              <== (self, dictionary, key: "non_existent_string_enum_array")
        wrongTypeStringEnumArray                <== (self, dictionary, key: "wrong_type_string_enum_array")
        
        doubleEnum							<== (self, dictionary, key: "double_enum")
        optionalDoubleEnum					<== (self, dictionary, key: "optional_double_enum")
        optionalDoubleEnumWithDefaultValue	<== (self, dictionary, key: "optional_double_enum_with_default_value")
        nonExistentDoubleEnum				<== (self, dictionary, key: "non_existent_double_enum")
        wrongTypeDoubleEnum					<== (self, dictionary, key: "wrong_type_double_enum")
        
        doubleEnumArray                         <== (self, dictionary, key: "double_enum_array")
        optionalDoubleEnumArray                 <== (self, dictionary, key: "optional_double_enum_array")
        optionalDoubleEnumArrayWithDefaultValue <== (self, dictionary, key: "optional_double_enum_array_with_default_value")
        nonExistentDoubleEnumArray              <== (self, dictionary, key: "non_existent_double_enum_array")
        wrongTypeDoubleEnumArray                <== (self, dictionary, key: "wrong_type_double_enum_array")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "string_enum")                                   <== stringEnum
        (dict, "optional_string_enum")                          <== optionalStringEnum
        (dict, "optional_string_enum_with_default_value")       <== optionalStringEnumWithDefaultValue
        (dict, "non_existent_string_enum")                      <== nonExistentStringEnum
        (dict, "wrong_type_string_enum")                        <== wrongTypeStringEnum
        (dict, "string_enum_array")                             <== stringEnumArray
        (dict, "optional_string_enum_array")                    <== optionalStringEnumArray
        (dict, "optional_string_enum_array_with_default_value") <== optionalStringEnumArrayWithDefaultValue
        (dict, "non_existent_string_enum")                      <== nonExistentStringEnum
        (dict, "wrong_type_string_enum")                        <== wrongTypeStringEnum
        (dict, "double_enum")                                   <== doubleEnum
        (dict, "optional_double_enum")                          <== optionalDoubleEnum
        (dict, "optional_double_enum_with_default_value")       <== optionalDoubleEnumWithDefaultValue
        (dict, "non_existent_double_enum")                      <== nonExistentDoubleEnum
        (dict, "wrong_type_double_enum")                        <== wrongTypeDoubleEnum
        (dict, "double_enum_array")                             <== doubleEnumArray
        (dict, "optional_double_enum_array")                    <== optionalDoubleEnumArray
        (dict, "optional_double_enum_array_with_default_value") <== optionalDoubleEnumArrayWithDefaultValue
        (dict, "non_existent_double_enum")                      <== nonExistentDoubleEnum
        (dict, "wrong_type_double_enum")                        <== wrongTypeDoubleEnum
        return dict
    }
}

