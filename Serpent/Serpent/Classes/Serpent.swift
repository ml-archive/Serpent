//
//  Serializable.swift
//  NOCore
//
//  Created by Kasper Welner on 22/01/15.
//  Copyright (c) 2015 Nodes. All rights reserved.
//

import Foundation

// MARK: - Serializable -

public protocol Serializable: Decodable, Encodable {}

//MARK: - EmbeddedMappable

public protocol EmbeddedMappable {
    
    var containsEmbeddedProperties: Bool { get }
}

public extension EmbeddedMappable {
    
    var containsEmbeddedProperties: Bool {
        return false
    }
    
    func embeddedDictAndKey(dict: NSDictionary, key: String) -> (dict: NSDictionary, key: String) {
        
        var dict = dict
        var key = key
        let paths = key.split(separator: "/")
        
        if paths.count > 1 {
            
            for (index, path) in paths.enumerated() {
                
                if index < paths.count - 1, let newDict = dict[path] as? NSDictionary {
                    dict = newDict
                } else if index == paths.count - 1 {
                    key = String(path)
                }
            }
            return (dict, key)
        }
        return (dict, key)
    }
}

// MARK: - Encodable -

public protocol Encodable: EmbeddedMappable {
    func encodableRepresentation() -> NSCoding
}

// MARK: - Decodable -

public protocol Decodable {
    init(dictionary:NSDictionary?)
}

public extension Decodable {
    public static func array(_ source: Any?) -> [Self] {
        guard let source = source as? [NSDictionary] else {
            return [Self]()
        }
        return source.map {
            Self(dictionary: ($0))
        }
    }
}

public extension Decodable {
    /// Maps the content of value for **key** in **dictionary** to generic type **T**, conforming to **Serializable** protocol.
    ///
    /// - parameter dictionary: An optional dictionary containing values which should be parsed.
    /// - parameter key: ValueForKey will be called on the dictionary to extract the value to be parsed
    ///
    /// - returns: A mapped object conforming to *Serializable*, or nil if parsing failed
    public func mapped<T>(_ dictionary: NSDictionary?, key: String) -> T? where T:Decodable {

        // Ensure the dictionary is not nil
        guard var dict = dictionary else { return nil }
        
        var key = key
        
        if containsEmbeddedProperties {
            let finalDictAndKey = embeddedDictAndKey(dict: dict, key: key)
            key = finalDictAndKey.1
            dict = finalDictAndKey.0
        }

        // Get the value from the dictionary for our key
        let sourceOpt = dict[key]

        // Check if we have the correct type and return it if possible
        if sourceOpt != nil && sourceOpt is NSDictionary {
            return T(dictionary: (sourceOpt as! NSDictionary))
        }
        return nil
    }
    
   

    /// Maps the content of value for **key** in **dictionary** to an array containing where elements is of generic type **T**, conforming to **Serializable** protocol.
    ///
    /// - parameter dictionary: An optional dictionary containing values which should be parsed.
    /// - parameter key: ValueForKey will be called on the dictionary to extract the value to be parsed.
    ///
    /// - returns: An array of mapped objects conforming to *Serializable*, or an empty array if parsing failed.

    public func mapped<T>(_ dictionary: NSDictionary?, key: String) -> T? where T:Sequence, T.Iterator.Element: Decodable {
        // Ensure the dictionary is not nil and get the value from the dictionary for our key
        guard let dict = dictionary, let sourceOpt = dict[key] else { return nil }

        if sourceOpt is [NSDictionary] {
            let source = (sourceOpt as! [NSDictionary])
            let finalArray = source.map { T.Iterator.Element.init(dictionary: $0) } as? T
            return finalArray
        }
        return nil
    }

    /// A generic mapping function that will try to parse primitive types from the provided dictionary.
    /// Currently supported types are `Int`, `Float`, `Double`, `Bool`, `Char` and `String`.
    ///
    /// The `key` parameter will be first used to check value in custom input key mappings and if
    /// no value is found, then `key` is used as the key to get the value stored in `dictionary`.
    ///
    ///  - parameter dictionary: An optional dictionary containing values which should be parsed.
    ///  - parameter key: The key which will be used to get the actual key from input key mappings
    ///  or as the actual key for the value being parsed from the dictionary.
    ///
    ///  - returns: The value of primitive type `T` or `nil` if parsing was unsuccessful.
    
    public func mapped<T>(_ dictionary: NSDictionary?, key: String) -> T? {

        // Ensure the dictionary is not nil
        guard var dict = dictionary else { return nil }
        var key = key
        
        if containsEmbeddedProperties {
            let finalDictAndKey = embeddedDictAndKey(dict: dict, key: key)
            key = finalDictAndKey.1
            dict = finalDictAndKey.0
        }
        

        // Get the value from the dictionary for our key
        let sourceOpt = dict[key]

        // First check to see if the types match
        if let match = sourceOpt as? T {
            return match
        }

        // Figure out what type is the value we got and parse accordingly
        switch sourceOpt {

        case (is String) where T.self is Int.Type:
            let source = (sourceOpt as! String)
            return Int(source) as? T

        case (is String) where T.self is Double.Type:
            let source = (sourceOpt as! String)
            return Double(source) as? T

        case (is NSString) where T.self is Bool.Type:
            let source = (sourceOpt as! NSString)
            return source.boolValue as? T

        case (is String) where T.self is Character.Type:
            let source = (sourceOpt as! String)
            return Character(source) as? T

        case (is NSNumber) where T.self is String.Type:
            let source = (sourceOpt as! NSNumber)
			return String(describing: source) as? T
            
        case (is Double) where T.self is Float.Type:
            let source = (sourceOpt as! Double)
            return Float(source) as? T
            
        default:
            return nil
        }
    }

    /// A generic mapping function that will try to parse an object of type `T` from the string
    /// value contained in the provided dictionary.
    ///
    /// The `key` parameter will be first used to check value in custom input key mappings and if
    /// no value is found, then `key` is used as the key to get the value stored in `dictionary`.
    ///
    /// - parameter dictionary: An optional dictionary containing the array which should be parsed.
    /// - parameter key: The key which will be used to get the actual key from input key mappings
    /// or as the actual key for the value being parsed from the dictionary.
    ///
    /// - returns: The value of type `T` or `nil` if parsing was unsuccessful.

    public func mapped<T:StringInitializable>(_ dictionary: NSDictionary?, key: String) -> T? {
        
        guard var dict = dictionary else { return nil }
        
        var key = key
        
        if containsEmbeddedProperties {
            let finalDictAndKey = embeddedDictAndKey(dict: dict, key: key)
            key = finalDictAndKey.1
            dict = finalDictAndKey.0
        }
        
        if let source = dict[key] as? String , source.isEmpty == false {
            return T.fromString(source)
        }
        return nil
    }

    /// A generic mapping function that will try to parse enumerations with raw value from the
    ///  provided dictionary.
    ///
    /// This function internally uses a variant of the generic `mapped()` function used to parse
    /// primitive types, which means that only enums with raw value of primitive type are supported.
    ///
    ///  The `key` parameter will be first used to check value in custom input key mappings and if
    /// no value is found, then `key` is used as the key to get the value stored in `dictionary`.
    ///
    /// - parameter dictionary: An optional dictionary containing values which should be parsed.
    /// - parameter key: The key which will be used to get the actual key from input key mappings
    /// or as the actual key for the value being parsed from the dictionary.
    ///
    ///  - returns: The enumeration of enum type `T` or `nil` if parsing was unsuccessful or
    /// enumeration does not exist.

    public func mapped<T:RawRepresentable>(_ dictionary: NSDictionary?, key: String) -> T? {
        guard let source: T.RawValue = self.mapped(dictionary, key: key) else {
            return nil
        }
        return T(rawValue: source)
    }

    /// A generic mapping function that will try to parse an array of enumerations with raw value from the
    /// array contained in the provided dictionary.
    ///
    /// The `key` parameter will be first used to check value in custom input key mappings and if
    /// no value is found, then `key` is used as the key to get the value stored in `dictionary`.
    ///
    /// - parameter dictionary: An optional dictionary containing the array which should be parsed.
    /// - parameter key: The key which will be used to get the actual key from input key mappings
    /// or as the actual key for the value being parsed from the dictionary.
    ///
    ///  - returns: An array of enum type `T` or an empty array if parsing was unsuccessful.

    public func mapped<T>(_ dictionary: NSDictionary?, key: String) -> T? where T:Sequence, T.Iterator.Element: RawRepresentable {
        if let dict = dictionary, let source = dict[key] as? [T.Iterator.Element.RawValue] {
            let finalArray = source.map { T.Iterator.Element.init(rawValue: $0)! }
            return (finalArray as! T)
        }
        return nil
    }

	/// A generic mapping function that will try to parse an object of type `T` from the hex string
	/// value contained in the provided dictionary.
    ///
    ///	The `key` parameter will be first used to check value in custom input key mappings and if
	/// no value is found, then `key` is used as the key to get the value stored in `dictionary`.
	
    ///	- parameter dictionary: An optional dictionary containing the array which should be parsed.
    ///	- parameter key: The key which will be used to get the actual key from input key mappings
    ///	or as the actual key for the value being parsed from the dictionary.
    ///
    ///	- returns: The value of type `T` or `nil` if parsing was unsuccessful.

	public func mapped<T: HexInitializable>(_ dictionary: NSDictionary?, key: String) -> T? {
        
        guard var dict = dictionary else { return nil }
        
        var key = key
        
        if containsEmbeddedProperties {
            let finalDictAndKey = embeddedDictAndKey(dict: dict, key: key)
            key = finalDictAndKey.1
            dict = finalDictAndKey.0
        }
        
		guard let source = dict[key] else {
			return nil
		}
		if let hexString = source as? String , hexString.isEmpty == false {
			return T.fromHexString(hexString)
		}
		return source as? T
	}	
}
