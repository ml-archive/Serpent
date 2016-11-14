//
//  NilTestModel.swift
//  Serializable
//
//  Created by Chris on 24/09/2016.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation
import Serpent

public struct NilModel {
	
	public enum NilModelType: Int {
		case first = 0
		case second = 1
	}
	
	var id: Int = 0
	var name = SimpleModel()
	var names = [SimpleModel]()
	var url = URL(string: "http://www.google.com")!
	var someEnum: NilModelType = .first
	var someEnumArray: [NilModelType] = []
	var somePrimitiveArray: [String] = []
	
	var optionalId: Int?
	var optionalName: SimpleModel?
	var optionalNames: [SimpleModel]?
	var optionalUrl: URL?
	var optionalEnum: NilModelType?
	var optionalEnumArray: [NilModelType]?
	var optionalPrimitiveArray: [String]?
}
extension NilModel: Serializable {
	public init(dictionary: NSDictionary?) {
		id                     <== (self, dictionary, "id")
		name                   <== (self, dictionary, "name")
		names                  <== (self, dictionary, "names")
		url                    <== (self, dictionary, "url")
		someEnum               <== (self, dictionary, "some_enum")
		someEnumArray          <== (self, dictionary, "some_enum_array")
		somePrimitiveArray     <== (self, dictionary, "some_primitive_array")
		optionalId             <== (self, dictionary, "optional_id")
		optionalName           <== (self, dictionary, "optional_name")
		optionalNames          <== (self, dictionary, "optional_names")
		optionalUrl            <== (self, dictionary, "optional_url")
		optionalEnum           <== (self, dictionary, "optional_enum")
		optionalEnumArray      <== (self, dictionary, "optional_enum_array")
		optionalPrimitiveArray <== (self, dictionary, "optional_primitive_array")
	}
	
	public func encodableRepresentation() -> NSCoding {
		let dict = NSMutableDictionary()
		(dict, "id")                       <== id
		(dict, "name")                     <== name
		(dict, "names")                    <== names
		(dict, "url")                      <== url
		(dict, "some_enum")                <== someEnum
		(dict, "some_enum_array")          <== someEnumArray
		(dict, "some_primitive_array")     <== somePrimitiveArray
		(dict, "optional_id")              <== optionalId
		(dict, "optional_name")            <== optionalName
		(dict, "optional_names")           <== optionalNames
		(dict, "optional_url")             <== optionalUrl
		(dict, "optional_enum")            <== optionalEnum
		(dict, "optional_enum_array")      <== optionalEnumArray
		(dict, "optional_primitive_array") <== optionalPrimitiveArray
		return dict
	}
}
