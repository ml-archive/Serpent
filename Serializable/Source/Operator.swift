//
//  Operator.swift
//  Serializable
//
//  Created by Chris Combs on 16/02/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation


// MARK: - Custom Operators -

infix operator <== { associativity left precedence 90 }

// For Encodable
public func <==<T>(left: (dict: NSMutableDictionary, key: String), right: T?) {
    left.dict.setValue(right as? AnyObject, forKey: left.key)
}

public func <==<T: Encodable>(left: (dict: NSMutableDictionary, key: String), right: T?) {
    left.dict.setValue(right?.encodableRepresentation(), forKey: left.key)
}

// For Decodable

// Primitive
public func <==<T, S where S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

// Serializable
public func <==<T, S where T: Decodable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: Decodable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

// Enum
public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: T? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: [T]?, right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: [T]? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

public func <==<T, S where T: RawRepresentable, S: Keymappable>(inout left: [T], right: (instance: S, dict: NSDictionary?, key: String)) {
    let value: [T]? = right.instance.mapped(right.dict, key: right.key)
    left = value ?? left
}

// [Serializable]
public func <==<T, S where T:_ArrayType, T:CollectionType, T.Generator.Element: Decodable, S: Keymappable>(inout left: T?, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}

public func <==<T, S where T:_ArrayType, T:CollectionType, T.Generator.Element: Decodable, S: Keymappable>(inout left: T, right: (instance: S, dict: NSDictionary?, key: String)) {
	let value: T? = right.instance.mapped(right.dict, key: right.key)
	left = value ?? left
}
