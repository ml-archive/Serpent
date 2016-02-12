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

    var doubleEnum: DoubleEnum = .NoneValue
    var optionalDoubleEnum: DoubleEnum?
    var optionalDoubleEnumWithDefaultValue: DoubleEnum? = .NoneValue
    var nonExistentDoubleEnum: DoubleEnum?
    var wrongTypeDoubleEnum: DoubleEnum?
}

extension EnumsTestModel:Serializable {
    init(dictionary: NSDictionary?) {
        stringEnum							<== (self, dictionary, key: "string_enum")
        optionalStringEnum					<== (self, dictionary, key: "optional_string_enum")
        optionalStringEnumWithDefaultValue	<== (self, dictionary, key: "optional_string_enum_with_default_value")
        nonExistentStringEnum				<== (self, dictionary, key: "non_existent_string_enum")
        wrongTypeStringEnum					<== (self, dictionary, key: "wrong_type_string_enum")
        doubleEnum							<== (self, dictionary, key: "double_enum")
        optionalDoubleEnum					<== (self, dictionary, key: "optional_double_enum")
        optionalDoubleEnumWithDefaultValue	<== (self, dictionary, key: "optional_double_enum_with_default_value")
        nonExistentDoubleEnum				<== (self, dictionary, key: "non_existent_double_enum")
        wrongTypeDoubleEnum					<== (self, dictionary, key: "wrong_type_double_enum")
    }

    func encodableRepresentation() -> NSCoding {
        let dict = NSMutableDictionary()
        (dict, "string_enum")								<== stringEnum.rawValue
        (dict, "optional_string_enum")						<== optionalStringEnum?.rawValue
        (dict, "optional_string_enum_with_default_value")	<== optionalStringEnumWithDefaultValue?.rawValue
        (dict, "non_existent_string_enum")					<== nonExistentStringEnum?.rawValue
        (dict, "wrong_type_string_enum")					<== wrongTypeStringEnum?.rawValue
        (dict, "double_enum")								<== doubleEnum.rawValue
        (dict, "optional_double_enum")						<== optionalDoubleEnum?.rawValue
        (dict, "optional_double_enum_with_default_value")	<== optionalDoubleEnumWithDefaultValue?.rawValue
        (dict, "non_existent_double_enum")					<== nonExistentDoubleEnum?.rawValue
        (dict, "wrong_type_double_enum")					<== wrongTypeDoubleEnum?.rawValue
        return dict
    }
}



